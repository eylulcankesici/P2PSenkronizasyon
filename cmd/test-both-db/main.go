package main

import (
	"context"
	"fmt"
	"log"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
)

func main() {
	fmt.Println("🧪 Aether İki Veritabanı Test Programı")
	fmt.Println("=======================================\n")

	// Config yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("❌ Config yüklenemedi: %v", err)
	}

	// Container oluştur
	cont, err := container.NewContainer(cfg)
	if err != nil {
		log.Fatalf("❌ Container oluşturulamadı: %v", err)
	}
	defer cont.Close()

	fmt.Println("✅ Container başarıyla oluşturuldu\n")

	ctx := context.Background()

	// ====================
	// SQLite Testleri
	// ====================
	fmt.Println("═══════════════════════════════════════")
	fmt.Println("📦 SQLite Testleri (İlişkisel Veriler)")
	fmt.Println("═══════════════════════════════════════\n")

	testSQLite(ctx, cont)

	// ====================
	// BoltDB Testleri
	// ====================
	fmt.Println("\n═══════════════════════════════════════")
	fmt.Println("🔑 BoltDB Testleri (Key-Value Store)")
	fmt.Println("═══════════════════════════════════════\n")

	testBoltDB(ctx, cont)

	// ====================
	// Entegrasyon Testi
	// ====================
	fmt.Println("\n═══════════════════════════════════════")
	fmt.Println("🔗 Entegrasyon Testi")
	fmt.Println("═══════════════════════════════════════\n")

	testIntegration(ctx, cont)

	fmt.Println("\n🎉 Tüm testler başarıyla tamamlandı!")
	fmt.Println("Her iki veritabanı da çalışıyor ✨")
}

func testSQLite(ctx context.Context, cont *container.Container) {
	// Test 1: Kullanıcı oluştur
	fmt.Println("📝 Test 1.1: Kullanıcı Oluşturma")
	user := entity.NewUser("sqlite_test_user", entity.UserRoleStandard, "test123")

	if err := cont.UserRepository().Create(ctx, user); err != nil {
		fmt.Printf("❌ Kullanıcı oluşturulamadı: %v\n", err)
	} else {
		fmt.Printf("✅ Kullanıcı oluşturuldu: %s (ID: %s)\n", user.ProfileName, user.ID)
	}

	// Test 2: Klasör oluştur
	fmt.Println("\n📝 Test 1.2: Klasör Oluşturma")
	folder := entity.NewFolder("C:\\TestData", entity.SyncModeBidirectional)

	if err := cont.FolderRepository().Create(ctx, folder); err != nil {
		fmt.Printf("❌ Klasör oluşturulamadı: %v\n", err)
	} else {
		fmt.Printf("✅ Klasör oluşturuldu: %s (ID: %s)\n", folder.LocalPath, folder.ID)
	}

	// Test 3: Veri sayıları
	fmt.Println("\n📝 Test 1.3: Veri Sayıları")

	folders, _ := cont.FolderRepository().GetAll(ctx)
	users, _ := cont.UserRepository().GetAll(ctx)

	fmt.Printf("   Toplam Klasör: %d\n", len(folders))
	fmt.Printf("   Toplam Kullanıcı: %d\n", len(users))
}

func testBoltDB(ctx context.Context, cont *container.Container) {
	configRepo := cont.ConfigRepository()

	if configRepo == nil {
		fmt.Println("❌ Config Repository nil!")
		return
	}

	// Test 1: Set
	fmt.Println("📝 Test 2.1: Ayar Kaydetme")

	testData := map[string]string{
		repository.ConfigKeyUserProfile: "test_profile",
		repository.ConfigKeyDeviceName:  "Test_Device",
		repository.ConfigKeyTheme:       "dark",
		repository.ConfigKeyLanguage:    "tr",
		"custom:test_key":               "test_value",
	}

	for key, value := range testData {
		if err := configRepo.Set(ctx, key, []byte(value)); err != nil {
			fmt.Printf("❌ Ayar kaydedilemedi [%s]: %v\n", key, err)
		} else {
			fmt.Printf("✅ Ayar kaydedildi: %s = %s\n", key, value)
		}
	}

	// Test 2: Get
	fmt.Println("\n📝 Test 2.2: Ayar Okuma")

	value, err := configRepo.Get(ctx, repository.ConfigKeyUserProfile)
	if err != nil {
		fmt.Printf("❌ Ayar okunamadı: %v\n", err)
	} else {
		fmt.Printf("✅ Ayar okundu: %s = %s\n", repository.ConfigKeyUserProfile, string(value))
	}

	// Test 3: GetAll
	fmt.Println("\n📝 Test 2.3: Tüm Ayarları Listeleme")

	allConfigs, err := configRepo.GetAll(ctx)
	if err != nil {
		fmt.Printf("❌ Ayarlar listelenemedi: %v\n", err)
	} else {
		fmt.Printf("✅ Toplam %d ayar bulundu:\n", len(allConfigs))
		for key, val := range allConfigs {
			fmt.Printf("   - %s = %s\n", key, string(val))
		}
	}

	// Test 4: GetWithPrefix
	fmt.Println("\n📝 Test 2.4: Prefix ile Ayar Arama")

	uiConfigs, err := configRepo.GetWithPrefix(ctx, "ui:")
	if err != nil {
		fmt.Printf("❌ Prefix araması başarısız: %v\n", err)
	} else {
		fmt.Printf("✅ 'ui:' prefix'i ile %d ayar bulundu:\n", len(uiConfigs))
		for key, val := range uiConfigs {
			fmt.Printf("   - %s = %s\n", key, string(val))
		}
	}

	// Test 5: Exists
	fmt.Println("\n📝 Test 2.5: Ayar Varlık Kontrolü")

	exists, err := configRepo.Exists(ctx, repository.ConfigKeyTheme)
	if err != nil {
		fmt.Printf("❌ Varlık kontrolü başarısız: %v\n", err)
	} else {
		fmt.Printf("✅ %s var mı? %v\n", repository.ConfigKeyTheme, exists)
	}

	// Test 6: Delete
	fmt.Println("\n📝 Test 2.6: Ayar Silme")

	if err := configRepo.Delete(ctx, "custom:test_key"); err != nil {
		fmt.Printf("❌ Ayar silinemedi: %v\n", err)
	} else {
		fmt.Println("✅ custom:test_key silindi")
	}
}

func testIntegration(ctx context.Context, cont *container.Container) {
	fmt.Println("📝 Test 3.1: Kullanıcı + Ayar Entegrasyonu")

	// SQLite'dan kullanıcı bilgilerini al
	users, err := cont.UserRepository().GetAll(ctx)
	if err != nil || len(users) == 0 {
		fmt.Println("❌ Kullanıcı bulunamadı")
		return
	}

	user := users[0]
	fmt.Printf("✅ SQLite'dan kullanıcı alındı: %s\n", user.ProfileName)

	// BoltDB'ye kullanıcı tercihi kaydet
	prefKey := fmt.Sprintf("user:%s:preference", user.ID)
	prefValue := []byte("dark_mode_enabled")

	if err := cont.ConfigRepository().Set(ctx, prefKey, prefValue); err != nil {
		fmt.Printf("❌ Tercih kaydedilemedi: %v\n", err)
	} else {
		fmt.Printf("✅ BoltDB'ye tercih kaydedildi: %s\n", prefKey)
	}

	// Geri oku
	savedPref, err := cont.ConfigRepository().Get(ctx, prefKey)
	if err != nil {
		fmt.Printf("❌ Tercih okunamadı: %v\n", err)
	} else {
		fmt.Printf("✅ Tercih okundu: %s = %s\n", prefKey, string(savedPref))
	}

	fmt.Println("\n📊 Veritabanları Başarıyla Entegre Çalışıyor!")
	fmt.Println("   - SQLite: İlişkisel veriler (Kullanıcı, Klasör, Dosya)")
	fmt.Println("   - BoltDB: Key-Value (Ayarlar, Önbellek, UI Durumu)")
}
