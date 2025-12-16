package boltdb

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"log"
	"strconv"

	bolt "go.etcd.io/bbolt"
	"golang.org/x/crypto/bcrypt"
)

// InitializeDesignSpecConfig BoltDB'yi tasarım spesifikasyonuna göre başlatır
func (c *Connection) InitializeDesignSpecConfig() error {
	if c.db == nil {
		if err := c.Open(); err != nil {
			return err
		}
	}

	log.Println("🔄 BoltDB tasarım spesifikasyonuna göre yapılandırılıyor...")

	return c.db.Update(func(tx *bolt.Tx) error {
		// Config bucket'ını al veya oluştur
		bucket, err := tx.CreateBucketIfNotExists([]byte("config"))
		if err != nil {
			return fmt.Errorf("config bucket oluşturulamadı: %w", err)
		}

		// Mevcut değerleri koru, sadece eksikleri ekle
		configs := c.getDesignSpecConfigs()

		for key, defaultValue := range configs {
			// Eğer key zaten varsa atla
			if existing := bucket.Get([]byte(key)); existing != nil {
				continue
			}

			// Yeni değeri ekle
			if err := bucket.Put([]byte(key), []byte(defaultValue)); err != nil {
				return fmt.Errorf("key %s eklenemedi: %w", key, err)
			}
			log.Printf("   ✓ %s = %s", key, defaultValue)
		}

		log.Println("✅ BoltDB başarıyla yapılandırıldı!")
		return nil
	})
}

// getDesignSpecConfigs tasarım spesifikasyonuna göre varsayılan konfigürasyonları döndürür
func (c *Connection) getDesignSpecConfigs() map[string]string {
	// Benzersiz instance ID oluştur
	instanceID := c.generateInstanceID()

	// Admin API hash oluştur (varsayılan: "admin123")
	adminHash, _ := bcrypt.GenerateFromPassword([]byte("admin123"), bcrypt.DefaultCost)

	return map[string]string{
		// TASARIM SPESİFİKASYONU - APP
		"app:instance_id": instanceID,

		// TASARIM SPESİFİKASYONU - ADMIN
		"admin:api_hash": string(adminHash),

		// TASARIM SPESİFİKASYONU - NETWORK
		"network:port":        "22000",
		"network:stun_server": "stun.l.google.com:19302",

		// TASARIM SPESİFİKASYONU - BANDWIDTH
		"bandwidth:limit_up":   "0", // 0 = sınırsız
		"bandwidth:limit_down": "0", // 0 = sınırsız

		// TASARIM SPESİFİKASYONU - USER
		"user:display_name": "Aether User",

		// TASARIM SPESİFİKASYONU - UI
		"ui:theme_mode": "dark",

		// TASARIM SPESİFİKASYONU - SECURITY
		// Not: admin_cert gerçek sertifika olmalı, şimdilik placeholder
		"security:admin_cert": "PLACEHOLDER_CERT",
	}
}

// generateInstanceID benzersiz bir instance ID oluşturur
func (c *Connection) generateInstanceID() string {
	bytes := make([]byte, 16)
	if _, err := rand.Read(bytes); err != nil {
		// Hata durumunda timestamp bazlı ID
		return fmt.Sprintf("instance-%d", 1729255621) // Unix timestamp
	}
	return hex.EncodeToString(bytes)
}

// GetConfig belirli bir config değerini okur
func (c *Connection) GetConfig(key string) (string, error) {
	var value string
	err := c.db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket([]byte("config"))
		if bucket == nil {
			return fmt.Errorf("config bucket bulunamadı")
		}

		val := bucket.Get([]byte(key))
		if val == nil {
			return fmt.Errorf("key bulunamadı: %s", key)
		}

		value = string(val)
		return nil
	})

	return value, err
}

// GetConfigInt config değerini integer olarak okur
func (c *Connection) GetConfigInt(key string) (int, error) {
	strVal, err := c.GetConfig(key)
	if err != nil {
		return 0, err
	}

	intVal, err := strconv.Atoi(strVal)
	if err != nil {
		return 0, fmt.Errorf("key %s integer değil: %w", key, err)
	}

	return intVal, nil
}

// SetConfig bir config değerini günceller
func (c *Connection) SetConfig(key, value string) error {
	return c.db.Update(func(tx *bolt.Tx) error {
		bucket := tx.Bucket([]byte("config"))
		if bucket == nil {
			return fmt.Errorf("config bucket bulunamadı")
		}

		return bucket.Put([]byte(key), []byte(value))
	})
}

// ListAllConfigs tüm config değerlerini listeler
func (c *Connection) ListAllConfigs() (map[string]string, error) {
	configs := make(map[string]string)

	err := c.db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket([]byte("config"))
		if bucket == nil {
			return fmt.Errorf("config bucket bulunamadı")
		}

		return bucket.ForEach(func(k, v []byte) error {
			configs[string(k)] = string(v)
			return nil
		})
	})

	return configs, err
}
