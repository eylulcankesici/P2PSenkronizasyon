package boltdb

import (
	"context"
	"fmt"
	"strings"

	"github.com/aether/sync/internal/domain/repository"
	"go.etcd.io/bbolt"
)

// ConfigRepository BoltDB üzerinde config repository implementasyonu
type ConfigRepository struct {
	conn       *Connection
	bucketName string
}

// NewConfigRepository yeni bir config repository oluşturur
func NewConfigRepository(conn *Connection) repository.ConfigRepository {
	return &ConfigRepository{
		conn:       conn,
		bucketName: "config",
	}
}

// Set bir konfigürasyon değeri ayarlar
func (r *ConfigRepository) Set(ctx context.Context, key string, value []byte) error {
	return r.conn.Set(r.bucketName, key, value)
}

// Get bir konfigürasyon değeri getirir
func (r *ConfigRepository) Get(ctx context.Context, key string) ([]byte, error) {
	value, err := r.conn.Get(r.bucketName, key)
	if err != nil {
		return nil, err
	}
	
	if value == nil {
		return nil, fmt.Errorf("key bulunamadı: %s", key)
	}
	
	return value, nil
}

// Delete bir konfigürasyon değerini siler
func (r *ConfigRepository) Delete(ctx context.Context, key string) error {
	return r.conn.Delete(r.bucketName, key)
}

// GetAll tüm konfigürasyon değerlerini getirir
func (r *ConfigRepository) GetAll(ctx context.Context) (map[string][]byte, error) {
	return r.conn.GetAll(r.bucketName)
}

// Exists bir anahtarın var olup olmadığını kontrol eder
func (r *ConfigRepository) Exists(ctx context.Context, key string) (bool, error) {
	value, err := r.conn.Get(r.bucketName, key)
	if err != nil {
		return false, err
	}
	return value != nil, nil
}

// GetWithPrefix belirli prefix ile başlayan tüm değerleri getirir
func (r *ConfigRepository) GetWithPrefix(ctx context.Context, prefix string) (map[string][]byte, error) {
	result := make(map[string][]byte)
	
	err := r.conn.DB().View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte(r.bucketName))
		if b == nil {
			return fmt.Errorf("bucket bulunamadı: %s", r.bucketName)
		}
		
		// Cursor ile prefix araması
		c := b.Cursor()
		prefixBytes := []byte(prefix)
		
		for k, v := c.Seek(prefixBytes); k != nil && strings.HasPrefix(string(k), prefix); k, v = c.Next() {
			key := make([]byte, len(k))
			value := make([]byte, len(v))
			copy(key, k)
			copy(value, v)
			result[string(key)] = value
		}
		
		return nil
	})
	
	return result, err
}

// GetString string değer getirir
func (r *ConfigRepository) GetString(ctx context.Context, key string) (string, error) {
	value, err := r.Get(ctx, key)
	if err != nil {
		return "", err
	}
	return string(value), nil
}

// SetString string değer ayarlar
func (r *ConfigRepository) SetString(ctx context.Context, key, value string) error {
	return r.Set(ctx, key, []byte(value))
}

// GetStringOrDefault string değer getirir, yoksa default döner
func (r *ConfigRepository) GetStringOrDefault(ctx context.Context, key, defaultValue string) string {
	value, err := r.GetString(ctx, key)
	if err != nil {
		return defaultValue
	}
	return value
}
