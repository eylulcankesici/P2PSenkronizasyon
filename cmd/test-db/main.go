package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
)

func main() {
	fmt.Println("🧪 Aether Veritabanı Test Programı")
	fmt.Println("=====================================\n")

	// Config yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("❌ Config yüklenemedi: %v", err)
	}

	fmt.Printf("📂 Data dizini: %s\n", cfg.App.DataDir)
	fmt.Printf("💾 SQLite DB: %s\n\n", filepath.Join(cfg.App.DataDir, "aether.db"))

	// Container oluştur
	cont, err := container.NewContainer(cfg)
	if err != nil {
		log.Fatalf("❌ Container oluşturulamadı: %v", err)
	}
	defer cont.Close()

	fmt.Println("✅ Container başarıyla oluşturuldu\n")

	ctx := context.Background()

	// Test 1: Kullanıcı Oluştur
	fmt.Println("📝 Test 1: Kullanıcı Oluşturma")
	fmt.Println("--------------------------------")
	user := entity.NewUser("test_user", entity.UserRoleAdmin, "test123")

	if err := cont.UserRepository().Create(ctx, user); err != nil {
		fmt.Printf("❌ Kullanıcı oluşturulamadı: %v\n\n", err)
	} else {
		fmt.Printf("✅ Kullanıcı oluşturuldu: %s (ID: %s)\n\n", user.ProfileName, user.ID)
	}

	// Test 2: Klasör Oluştur
	fmt.Println("📝 Test 2: Klasör Oluşturma")
	fmt.Println("--------------------------------")

	// Test klasörü oluştur
	testFolderPath := filepath.Join(os.TempDir(), "aether_test_folder")
	if err := os.MkdirAll(testFolderPath, 0755); err != nil {
		log.Fatalf("❌ Test klasörü oluşturulamadı: %v", err)
	}
	fmt.Printf("📁 Test klasörü: %s\n", testFolderPath)

	folder := entity.NewFolder(testFolderPath, entity.SyncModeBidirectional)

	if err := cont.FolderRepository().Create(ctx, folder); err != nil {
		fmt.Printf("❌ Klasör oluşturulamadı: %v\n\n", err)
	} else {
		fmt.Printf("✅ Klasör oluşturuldu: %s (ID: %s)\n\n", folder.LocalPath, folder.ID)
	}

	// Test 3: Klasörleri Listele
	fmt.Println("📝 Test 3: Klasörleri Listeleme")
	fmt.Println("--------------------------------")

	folders, err := cont.FolderRepository().GetAll(ctx)
	if err != nil {
		fmt.Printf("❌ Klasörler listelenemedi: %v\n\n", err)
	} else {
		fmt.Printf("✅ Toplam %d klasör bulundu:\n", len(folders))
		for i, f := range folders {
			fmt.Printf("   %d. %s\n", i+1, f.LocalPath)
			fmt.Printf("      - ID: %s\n", f.ID)
			fmt.Printf("      - Mod: %s\n", f.SyncMode)
			fmt.Printf("      - Aktif: %v\n", f.IsActive)
		}
		fmt.Println()
	}

	// Test 4: Kullanıcıları Listele
	fmt.Println("📝 Test 4: Kullanıcıları Listeleme")
	fmt.Println("--------------------------------")

	users, err := cont.UserRepository().GetAll(ctx)
	if err != nil {
		fmt.Printf("❌ Kullanıcılar listelenemedi: %v\n\n", err)
	} else {
		fmt.Printf("✅ Toplam %d kullanıcı bulundu:\n", len(users))
		for i, u := range users {
			fmt.Printf("   %d. %s (%s)\n", i+1, u.ProfileName, u.Role)
		}
		fmt.Println()
	}

	// Test 5: Klasör Güncelle (Toggle Active)
	if len(folders) > 0 {
		fmt.Println("📝 Test 5: Klasör Durumunu Değiştirme")
		fmt.Println("--------------------------------")

		testFolder := folders[0]
		fmt.Printf("Klasör önceki durumu: Aktif=%v\n", testFolder.IsActive)

		// Durumu değiştir
		testFolder.IsActive = !testFolder.IsActive
		if err := cont.FolderRepository().Update(ctx, testFolder); err != nil {
			fmt.Printf("❌ Klasör güncellenemedi: %v\n\n", err)
		} else {
			fmt.Printf("✅ Klasör güncellendi: Aktif=%v\n\n", testFolder.IsActive)
		}
	}

	// Test 6: Temizlik (Opsiyonel)
	fmt.Println("📝 Test 6: Temizlik")
	fmt.Println("--------------------------------")

	cleanup := promptYesNo("Test verilerini silmek ister misiniz? (E/H)")

	if cleanup {
		// Klasörü sil
		if len(folders) > 0 {
			for _, f := range folders {
				if err := cont.FolderRepository().Delete(ctx, f.ID); err != nil {
					fmt.Printf("❌ Klasör silinemedi: %v\n", err)
				} else {
					fmt.Printf("✅ Klasör silindi: %s\n", f.LocalPath)
				}
			}
		}

		// Kullanıcıyı sil
		if err := cont.UserRepository().Delete(ctx, user.ID); err != nil {
			fmt.Printf("❌ Kullanıcı silinemedi: %v\n", err)
		} else {
			fmt.Printf("✅ Kullanıcı silindi: %s\n", user.ProfileName)
		}

		// Test klasörünü sil
		if err := os.RemoveAll(testFolderPath); err != nil {
			fmt.Printf("❌ Test klasörü silinemedi: %v\n", err)
		} else {
			fmt.Printf("✅ Test klasörü silindi: %s\n", testFolderPath)
		}
	} else {
		fmt.Println("⏭️  Test verileri korundu")
	}

	fmt.Println("\n🎉 Tüm testler tamamlandı!")
}

func promptYesNo(question string) bool {
	var response string
	fmt.Printf("%s ", question)
	fmt.Scanln(&response)
	return response == "E" || response == "e" || response == "Y" || response == "y"
}
