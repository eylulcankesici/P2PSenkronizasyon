# Veritabanı Mimarisi Karşılaştırması

Tarih: 18 Ekim 2025

## 📊 Genel Durum

| Veritabanı | Tasarım | Mevcut | Durum |
|------------|---------|--------|-------|
| **SQLite** | 6 tablo | 7 tablo | ⚠️ Kısmen Uyumlu |
| **BoltDB** | 9 key | 5 key | ❌ Eksikler Var |

---

## 🗄️ SQLite Veritabanı Karşılaştırması

### ✅ **Tablo 1: folders (Klasörler)**

| Alan | Tasarım | Mevcut | Durum |
|------|---------|--------|-------|
| `id` | TEXT PRIMARY KEY | ✅ TEXT PRIMARY KEY | ✅ TAM |
| `name` | TEXT NOT NULL | ❌ YOK | ⚠️ EKSİK |
| `local_path` | TEXT UNIQUE NOT NULL | ✅ TEXT UNIQUE NOT NULL | ✅ TAM |
| `sync_mode` | TEXT NOT NULL | ✅ TEXT NOT NULL | ✅ TAM |
| `last_scan_time` | INTEGER NOT NULL | ✅ DATETIME | ⚠️ Tip Farkı |
| `device_id` | TEXT NOT NULL | ❌ YOK | ⚠️ EKSİK |
| - | - | ✅ is_active | ➕ EKSTRA |
| - | - | ✅ created_at | ➕ EKSTRA |
| - | - | ✅ updated_at | ➕ EKSTRA |

**Sorunlar:**
- ❌ `name` alanı eksik (kullanıcı tanımlı görünen isim)
- ❌ `device_id` alanı eksik (klasörü oluşturan cihaz)
- ⚠️ `last_scan_time` INTEGER yerine DATETIME kullanılıyor

---

### ✅ **Tablo 2: files (Dosyalar)**

| Alan | Tasarım | Mevcut | Durum |
|------|---------|--------|-------|
| `id` | TEXT PRIMARY KEY | ✅ TEXT PRIMARY KEY | ✅ TAM |
| `folder_id` | TEXT FK NOT NULL | ✅ TEXT FK NOT NULL | ✅ TAM |
| `relative_path` | TEXT NOT NULL | ✅ TEXT NOT NULL | ✅ TAM |
| `size` | INTEGER NOT NULL | ✅ INTEGER NOT NULL | ✅ TAM |
| `mod_time` | INTEGER NOT NULL | ✅ DATETIME NOT NULL | ⚠️ Tip Farkı |
| `global_hash` | TEXT NOT NULL | ✅ TEXT (nullable) | ⚠️ NULL olabiliyor |
| `is_deleted` | BOOLEAN NOT NULL | ✅ BOOLEAN NOT NULL | ✅ TAM |
| - | - | ✅ chunk_count | ➕ EKSTRA |
| - | - | ✅ created_at | ➕ EKSTRA |
| - | - | ✅ updated_at | ➕ EKSTRA |

**Sorunlar:**
- ⚠️ `mod_time` INTEGER yerine DATETIME kullanılıyor
- ⚠️ `global_hash` NULL olabiliyor (tasarımda NOT NULL)

---

### ⚠️ **Tablo 3: chunks (Parçalar)**

| Alan | Tasarım | Mevcut | Durum |
|------|---------|--------|-------|
| `hash` | TEXT PRIMARY KEY | ❌ `id` TEXT PRIMARY KEY | ⚠️ FARKLI |
| `size` | INTEGER NOT NULL | ❌ `length` INTEGER | ⚠️ FARKLI AD |
| `creation_time` | INTEGER NOT NULL | ✅ `created_at` DATETIME | ⚠️ Tip/Ad Farkı |
| `is_local` | BOOLEAN NOT NULL | ❌ YOK | ⚠️ EKSİK |
| - | - | ✅ file_id FK | ➕ FARKLI YAPILANMA |
| - | - | ✅ offset | ➕ EKSTRA |
| - | - | ✅ device_availability | ➕ EKSTRA |

**BÜYÜK SORUN:**
- ❌ **Tasarımda `chunks` tablosu dosyalardan bağımsız, paylaşılabilir parçaları temsil ediyor**
- ❌ **Mevcut yapıda `chunks` her dosyaya özel ve `file_id` FK içeriyor**
- ❌ `hash` yerine `id` kullanılıyor (hash PRIMARY KEY olmalı!)
- ❌ `is_local` alanı yok (parçanın bu cihazda olup olmadığı)

---

### ❌ **Tablo 4: file_chunks (Dosya-Parça İlişkisi)**

| Tasarım | Mevcut | Durum |
|---------|--------|-------|
| Gerekli | ❌ YOK | **TAM EKSİK** |

**Gereken Yapı:**
```sql
CREATE TABLE file_chunks (
    file_id TEXT NOT NULL,
    chunk_hash TEXT NOT NULL,
    chunk_index INTEGER NOT NULL,
    PRIMARY KEY(file_id, chunk_index),
    FOREIGN KEY (file_id) REFERENCES files(id),
    FOREIGN KEY (chunk_hash) REFERENCES chunks(hash)
);
```

**BÜYÜK SORUN:**
- ❌ **Bu tablo tamamen eksik!**
- ❌ Dosyaların hangi parçalardan oluştuğu kaydedilemiyor
- ❌ Parça deduplication yapılamıyor (aynı parça birden fazla dosyada kullanılamıyor)

---

### ✅ **Tablo 5: peers (Eş Cihazlar)**

| Alan | Tasarım | Mevcut | Durum |
|------|---------|--------|-------|
| `device_id` | TEXT PRIMARY KEY | ✅ TEXT PRIMARY KEY | ✅ TAM |
| `name` | TEXT NOT NULL | ✅ TEXT NOT NULL | ✅ TAM |
| `addresses` | TEXT | ✅ `known_addresses` TEXT | ✅ TAM (ad farkı) |
| `is_trusted` | BOOLEAN NOT NULL | ✅ BOOLEAN NOT NULL | ✅ TAM |
| `last_seen` | INTEGER | ✅ DATETIME NOT NULL | ⚠️ Tip Farkı |
| - | - | ✅ status | ➕ EKSTRA |
| - | - | ✅ public_key | ➕ EKSTRA |
| - | - | ✅ created_at | ➕ EKSTRA |
| - | - | ✅ updated_at | ➕ EKSTRA |

**Durum:** ✅ Genel olarak uyumlu

---

### ❌ **Tablo 6: peer_folder_status (Eş-Klasör Durumu)**

| Tasarım | Mevcut | Durum |
|---------|--------|-------|
| Gerekli | ❌ YOK | **TAM EKSİK** |

**Gereken Yapı:**
```sql
CREATE TABLE peer_folder_status (
    folder_id TEXT NOT NULL,
    peer_id TEXT NOT NULL,
    global_version INTEGER NOT NULL,
    sync_state TEXT,
    PRIMARY KEY(folder_id, peer_id),
    FOREIGN KEY (folder_id) REFERENCES folders(id),
    FOREIGN KEY (peer_id) REFERENCES peers(device_id)
);
```

**BÜYÜK SORUN:**
- ❌ **Bu tablo tamamen eksik!**
- ❌ Hangi eşin hangi klasörün hangi versiyonuna sahip olduğu takip edilemiyor
- ❌ P2P senkronizasyon durumu izlenemiyor

---

### ➕ **Ekstra Tablolar (Tasarımda Yok)**

#### 1. **users** (Kullanıcılar)
```sql
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    profile_name TEXT NOT NULL UNIQUE,
    role TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
)
```
**Not:** Tasarımda yok, ancak multi-user desteği için yararlı.

#### 2. **file_versions** (Dosya Versiyonları)
```sql
CREATE TABLE file_versions (
    id TEXT PRIMARY KEY,
    file_id TEXT NOT NULL,
    version_number INTEGER NOT NULL,
    backup_path TEXT NOT NULL,
    original_path TEXT NOT NULL,
    size INTEGER NOT NULL,
    hash TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by_peer_id TEXT,
    FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
    UNIQUE(file_id, version_number)
)
```
**Not:** Tasarımda yok, ancak çakışma çözümü ve yedekleme için yararlı.

---

## 🔑 BoltDB/Key-Value Karşılaştırması

### ❌ Eksik Anahtarlar

| Anahtar (Key) | Tasarım | Mevcut | Durum |
|---------------|---------|--------|-------|
| `app:instance_id` | TEXT | ❌ YOK | **EKSİK** |
| `admin:api_hash` | TEXT | ❌ YOK | **EKSİK** |
| `network:port` | INTEGER | ❌ YOK | **EKSİK** |
| `network:stun_server` | TEXT | ❌ YOK | **EKSİK** |
| `bandwidth:limit_up` | INTEGER | ❌ YOK | **EKSİK** |
| `bandwidth:limit_down` | INTEGER | ❌ YOK | **EKSİK** |
| `user:display_name` | TEXT | ❌ YOK | **EKSİK** |
| `ui:theme_mode` | TEXT | ✅ `ui:theme` | ✅ (ad farkı) |
| `security:admin_cert` | BLOB | ❌ YOK | **EKSİK** |

### ✅ Mevcut Anahtarlar

| Anahtar | Değer Örneği | Not |
|---------|--------------|-----|
| `device:name` | Test_Device | Tasarımda yok, yararlı |
| `ui:language` | tr | Tasarımda yok, yararlı |
| `ui:theme` | dark | ✅ Tasarımda `ui:theme_mode` |
| `user:profile_name` | test_profile | Tasarımda `user:display_name` |
| `user:....:preference` | dark_mode_enabled | Tasarımda yok |

---

## 🚨 Kritik Sorunlar

### 🔴 **Yüksek Öncelik**

1. **`file_chunks` tablosu eksik** ❌
   - Dosyaların parçalardan oluşumu kaydedilemiyor
   - Deduplication yapılamıyor
   - P2P parça transferi yapılamaz

2. **`chunks` tablosu yanlış yapılandırılmış** ⚠️
   - `hash` PRIMARY KEY olmalı, `id` değil
   - `is_local` alanı eksik
   - Dosyalardan bağımsız olmalı (şu an file_id FK var)

3. **`peer_folder_status` tablosu eksik** ❌
   - Eş cihazların klasör versiyonları takip edilemiyor
   - P2P senkronizasyon durumu bilinmiyor

### 🟡 **Orta Öncelik**

4. **`folders` tablosunda eksikler:**
   - `name` alanı yok (kullanıcı tanımlı isim)
   - `device_id` alanı yok (klasörü oluşturan cihaz)

5. **BoltDB yapılandırması eksik:**
   - P2P ağ ayarları yok (`network:port`, `network:stun_server`)
   - Bant genişliği limitleri yok
   - Admin API güvenliği yok (`admin:api_hash`)
   - Uygulama instance ID yok (`app:instance_id`)

### 🟢 **Düşük Öncelik**

6. **Veri tipi farklılıkları:**
   - `INTEGER` (Unix timestamp) yerine `DATETIME` kullanılıyor
   - Performans farkı minimal, ancak tutarlılık için düzeltilmeli

---

## 📋 Önerilen Eylem Planı

### Faz 1: Kritik Yapısal Düzeltmeler (Öncelik: Yüksek)

1. **`chunks` tablosunu yeniden yapılandır:**
   ```sql
   DROP TABLE chunks;
   CREATE TABLE chunks (
       hash TEXT PRIMARY KEY,
       size INTEGER NOT NULL,
       creation_time INTEGER NOT NULL,
       is_local BOOLEAN NOT NULL DEFAULT 1
   );
   ```

2. **`file_chunks` ilişki tablosunu oluştur:**
   ```sql
   CREATE TABLE file_chunks (
       file_id TEXT NOT NULL,
       chunk_hash TEXT NOT NULL,
       chunk_index INTEGER NOT NULL,
       PRIMARY KEY(file_id, chunk_index),
       FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
       FOREIGN KEY (chunk_hash) REFERENCES chunks(hash)
   );
   ```

3. **`peer_folder_status` tablosunu oluştur:**
   ```sql
   CREATE TABLE peer_folder_status (
       folder_id TEXT NOT NULL,
       peer_id TEXT NOT NULL,
       global_version INTEGER NOT NULL,
       sync_state TEXT NOT NULL DEFAULT 'unknown',
       last_updated INTEGER,
       PRIMARY KEY(folder_id, peer_id),
       FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE,
       FOREIGN KEY (peer_id) REFERENCES peers(device_id) ON DELETE CASCADE
   );
   ```

### Faz 2: `folders` Tablosu Güncellemeleri

4. **`folders` tablosuna eksik alanları ekle:**
   ```sql
   ALTER TABLE folders ADD COLUMN name TEXT;
   ALTER TABLE folders ADD COLUMN device_id TEXT;
   ```

### Faz 3: BoltDB Yapılandırması

5. **Eksik BoltDB anahtarlarını ekle:**
   - `app:instance_id` → UUID oluştur
   - `network:port` → 22000 (varsayılan)
   - `network:stun_server` → `stun.l.google.com:19302`
   - `bandwidth:limit_up` → 0 (sınırsız)
   - `bandwidth:limit_down` → 0 (sınırsız)
   - `admin:api_hash` → bcrypt hash

### Faz 4: Veri Tipi Tutarlılığı (Opsiyonel)

6. **DATETIME → INTEGER dönüşümü** (tercihe bağlı)

---

## 📊 Uyumluluk Skoru

| Kategori | Puan | Açıklama |
|----------|------|----------|
| **SQLite Tablo Sayısı** | 5/6 | 1 tablo eksik (peer_folder_status) |
| **SQLite Yapı Uyumu** | 65/100 | Önemli yapısal farklar var |
| **BoltDB Anahtar Sayısı** | 2/9 | 7 anahtar eksik |
| **BoltDB Yapı Uyumu** | 25/100 | Çoğu P2P ayarı eksik |
| **Genel Uyum** | 45/100 | **Ciddi iyileştirme gerekli** |

---

## ✅ Sonuç ve Öneri

**Mevcut Durum:** 
- Temel dosya/klasör senkronizasyonu için yapı var ✅
- P2P altyapısı için kritik tablolar eksik ❌
- BoltDB konfigürasyonu minimal ⚠️

**Öneri:**
1. **Faz 1'i hemen uygula** (P2P için gerekli)
2. Faz 2 ve 3'ü kademeli olarak ekle
3. Migration scriptleri oluştur (veri kaybı önleme)
4. Test ortamında önce dene

**Risk:** Mevcut verileri korumak için dikkatli migration gerekiyor.

