package sqlite

import (
	"database/sql"
	"fmt"
	"path/filepath"
	
	_ "modernc.org/sqlite"
)

// Connection SQLite veritabanı bağlantısını yönetir
// Single Responsibility: Sadece DB bağlantı yönetimi
type Connection struct {
	db       *sql.DB
	dbPath   string
	isOpen   bool
}

// NewConnection yeni bir SQLite connection oluşturur
func NewConnection(dbPath string) (*Connection, error) {
	return &Connection{
		dbPath: dbPath,
		isOpen: false,
	}, nil
}

// Open veritabanı bağlantısını açar
func (c *Connection) Open() error {
	if c.isOpen {
		return nil
	}
	
	// SQLite bağlantısı aç
	db, err := sql.Open("sqlite", c.dbPath)
	if err != nil {
		return fmt.Errorf("sqlite bağlantısı açılamadı: %w", err)
	}
	
	// Bağlantı havuzu ayarları
	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(5)
	
	// WAL modu etkinleştir (daha iyi concurrency)
	if _, err := db.Exec("PRAGMA journal_mode=WAL"); err != nil {
		db.Close()
		return fmt.Errorf("WAL modu etkinleştirilemedi: %w", err)
	}
	
	// Foreign key'leri etkinleştir
	if _, err := db.Exec("PRAGMA foreign_keys=ON"); err != nil {
		db.Close()
		return fmt.Errorf("foreign key'ler etkinleştirilemedi: %w", err)
	}
	
	c.db = db
	c.isOpen = true
	
	return nil
}

// Close veritabanı bağlantısını kapatır
func (c *Connection) Close() error {
	if !c.isOpen || c.db == nil {
		return nil
	}
	
	err := c.db.Close()
	c.isOpen = false
	return err
}

// DB alt seviye *sql.DB'yi döner
func (c *Connection) DB() *sql.DB {
	return c.db
}

// IsOpen bağlantının açık olup olmadığını kontrol eder
func (c *Connection) IsOpen() bool {
	return c.isOpen
}

// Ping veritabanı bağlantısını test eder
func (c *Connection) Ping() error {
	if !c.isOpen {
		return fmt.Errorf("veritabanı bağlantısı kapalı")
	}
	return c.db.Ping()
}

// GetPath veritabanı dosya yolunu döner
func (c *Connection) GetPath() string {
	return c.dbPath
}

// GetDirPath veritabanı dizin yolunu döner
func (c *Connection) GetDirPath() string {
	return filepath.Dir(c.dbPath)
}


