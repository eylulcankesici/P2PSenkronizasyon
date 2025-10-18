package boltdb

import (
	"fmt"
	"log"
	"time"

	"go.etcd.io/bbolt"
)

// Connection BoltDB bağlantısını yönetir
type Connection struct {
	db   *bbolt.DB
	path string
}

// NewConnection yeni bir BoltDB connection oluşturur
func NewConnection(path string) *Connection {
	return &Connection{
		path: path,
	}
}

// Open veritabanı bağlantısını açar
func (c *Connection) Open() error {
	db, err := bbolt.Open(c.path, 0600, &bbolt.Options{
		Timeout: 1 * time.Second,
	})
	if err != nil {
		return fmt.Errorf("boltdb açılamadı: %w", err)
	}

	c.db = db
	log.Printf("BoltDB bağlantısı açıldı: %s", c.path)
	
	// Varsayılan bucket'ları oluştur
	if err := c.initBuckets(); err != nil {
		return fmt.Errorf("bucket'lar oluşturulamadı: %w", err)
	}

	return nil
}

// Close veritabanı bağlantısını kapatır
func (c *Connection) Close() error {
	if c.db != nil {
		return c.db.Close()
	}
	return nil
}

// DB bbolt.DB instance'ını döndürür
func (c *Connection) DB() *bbolt.DB {
	return c.db
}

// initBuckets varsayılan bucket'ları oluşturur
func (c *Connection) initBuckets() error {
	return c.db.Update(func(tx *bbolt.Tx) error {
		buckets := []string{
			"config",      // Ayarlar için
			"cache",       // Önbellek için
			"settings",    // Kullanıcı ayarları
			"ui_state",    // UI durumu
		}

		for _, bucket := range buckets {
			_, err := tx.CreateBucketIfNotExists([]byte(bucket))
			if err != nil {
				return fmt.Errorf("bucket oluşturulamadı %s: %w", bucket, err)
			}
		}

		return nil
	})
}

// Bucket yardımcı metodları

// Set bir key-value çiftini bucket'a kaydeder
func (c *Connection) Set(bucket, key string, value []byte) error {
	return c.db.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte(bucket))
		if b == nil {
			return fmt.Errorf("bucket bulunamadı: %s", bucket)
		}
		return b.Put([]byte(key), value)
	})
}

// Get bir key'e karşılık gelen value'yu okur
func (c *Connection) Get(bucket, key string) ([]byte, error) {
	var value []byte
	
	err := c.db.View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte(bucket))
		if b == nil {
			return fmt.Errorf("bucket bulunamadı: %s", bucket)
		}
		
		v := b.Get([]byte(key))
		if v != nil {
			// Copy the value because it's only valid during the transaction
			value = make([]byte, len(v))
			copy(value, v)
		}
		
		return nil
	})
	
	return value, err
}

// Delete bir key'i bucket'tan siler
func (c *Connection) Delete(bucket, key string) error {
	return c.db.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte(bucket))
		if b == nil {
			return fmt.Errorf("bucket bulunamadı: %s", bucket)
		}
		return b.Delete([]byte(key))
	})
}

// GetAll bir bucket'taki tüm key-value çiftlerini döndürür
func (c *Connection) GetAll(bucket string) (map[string][]byte, error) {
	result := make(map[string][]byte)
	
	err := c.db.View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte(bucket))
		if b == nil {
			return fmt.Errorf("bucket bulunamadı: %s", bucket)
		}
		
		return b.ForEach(func(k, v []byte) error {
			key := make([]byte, len(k))
			value := make([]byte, len(v))
			copy(key, k)
			copy(value, v)
			result[string(key)] = value
			return nil
		})
	})
	
	return result, err
}

// Clear bir bucket'taki tüm veriyi siler
func (c *Connection) Clear(bucket string) error {
	return c.db.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte(bucket))
		if b == nil {
			return fmt.Errorf("bucket bulunamadı: %s", bucket)
		}
		
		// Tüm key'leri sil
		return b.ForEach(func(k, v []byte) error {
			return b.Delete(k)
		})
	})
}
