package filesystem

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
)

// SymlinkManager sembolik link yönetimini sağlar
type SymlinkManager struct{}

// NewSymlinkManager yeni bir SymlinkManager oluşturur
func NewSymlinkManager() *SymlinkManager {
	return &SymlinkManager{}
}

// CreateDesktopSymlink masaüstünde sembolik link oluşturur
// target: Gerçek klasör yolu (synced_folders içinde)
// name: Sembolik link adı
func (sm *SymlinkManager) CreateDesktopSymlink(target, name string) (string, error) {
	// Desktop path'ini al
	desktopPath, err := sm.getDesktopPath()
	if err != nil {
		return "", fmt.Errorf("desktop path alınamadı: %w", err)
	}
	
	// Symlink path'i
	symlinkPath := filepath.Join(desktopPath, name)
	
	// Zaten varsa atla
	if _, err := os.Lstat(symlinkPath); err == nil {
		// Mevcut symlink'i kontrol et
		if sm.isValidSymlink(symlinkPath, target) {
			return symlinkPath, nil
		}
		// Geçersiz symlink, sil ve yeniden oluştur
		os.Remove(symlinkPath)
	}
	
	// Platform'a göre symlink oluştur
	if err := sm.createSymlink(target, symlinkPath); err != nil {
		return "", fmt.Errorf("symlink oluşturulamadı: %w", err)
	}
	
	return symlinkPath, nil
}

// RemoveDesktopSymlink masaüstündeki symlink'i siler
func (sm *SymlinkManager) RemoveDesktopSymlink(name string) error {
	desktopPath, err := sm.getDesktopPath()
	if err != nil {
		return fmt.Errorf("desktop path alınamadı: %w", err)
	}
	
	symlinkPath := filepath.Join(desktopPath, name)
	
	// Symlink var mı kontrol et
	info, err := os.Lstat(symlinkPath)
	if err != nil {
		if os.IsNotExist(err) {
			return nil // Zaten yok
		}
		return fmt.Errorf("symlink kontrol edilemedi: %w", err)
	}
	
	// Symlink veya directory ise sil
	if info.Mode()&os.ModeSymlink != 0 || info.IsDir() {
		if err := os.Remove(symlinkPath); err != nil {
			return fmt.Errorf("symlink silinemedi: %w", err)
		}
	}
	
	return nil
}

// getDesktopPath kullanıcının masaüstü path'ini döner
func (sm *SymlinkManager) getDesktopPath() (string, error) {
	switch runtime.GOOS {
	case "windows":
		// Windows: USERPROFILE\Desktop
		userProfile := os.Getenv("USERPROFILE")
		if userProfile == "" {
			return "", fmt.Errorf("USERPROFILE environment variable bulunamadı")
		}
		return filepath.Join(userProfile, "Desktop"), nil
	case "darwin":
		// macOS: ~/Desktop
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, "Desktop"), nil
	case "linux":
		// Linux: ~/Desktop
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, "Desktop"), nil
	default:
		return "", fmt.Errorf("desteklenmeyen platform: %s", runtime.GOOS)
	}
}

// createSymlink platform'a göre symlink oluşturur
func (sm *SymlinkManager) createSymlink(target, link string) error {
	switch runtime.GOOS {
	case "windows":
		// Windows'ta Directory Junction kullan (Administrator gerektirmez)
		// mklink /J "link" "target"
		cmd := exec.Command("cmd", "/C", "mklink", "/J", link, target)
		output, err := cmd.CombinedOutput()
		if err != nil {
			return fmt.Errorf("mklink hatası: %v, output: %s", err, string(output))
		}
		return nil
	case "darwin", "linux":
		// Unix: os.Symlink kullan
		return os.Symlink(target, link)
	default:
		return fmt.Errorf("desteklenmeyen platform: %s", runtime.GOOS)
	}
}

// isValidSymlink symlink'in hedefi doğru mu kontrol eder
func (sm *SymlinkManager) isValidSymlink(link, expectedTarget string) bool {
	target, err := os.Readlink(link)
	if err != nil {
		// Readlink başarısızsa, Junction olabilir (Windows)
		// Junction'lar için Lstat kullan
		info, err := os.Lstat(link)
		if err != nil {
			return false
		}
		// Directory ve reparse point ise Junction'dır
		if info.IsDir() && info.Mode()&os.ModeSymlink == 0 {
			// Windows Junction - target kontrolü yapmadan kabul et
			return true
		}
		return false
	}
	
	// Target'ı normalize et ve karşılaştır
	targetAbs, _ := filepath.Abs(target)
	expectedAbs, _ := filepath.Abs(expectedTarget)
	
	return targetAbs == expectedAbs
}

// GetSymlinkTarget symlink'in hedefini döner
func (sm *SymlinkManager) GetSymlinkTarget(link string) (string, error) {
	return os.Readlink(link)
}

