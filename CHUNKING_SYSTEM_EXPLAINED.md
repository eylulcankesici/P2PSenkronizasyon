# 🧩 Aether Chunking Sistemi - Detaylı Açıklama

## 📚 İçindekiler
1. [Genel Mantık](#genel-mantık)
2. [Veritabanı Yapısı](#veritabanı-yapısı)
3. [Disk Depolama](#disk-depolama)
4. [Deduplication Mekanizması](#deduplication-mekanizması)
5. [Örnek Senaryo](#örnek-senaryo)

---

## 🎯 Genel Mantık

Chunking sistemi **iki katmanlı** bir yapıya sahip:

```
┌─────────────────────────────────────────────────────────────┐
│                  KULLANICI DOSYASI                          │
│              (Örn: video.mp4 - 10 MB)                       │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│               CHUNKING İŞLEMİ (256 KB)                      │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐      ┌──────┐        │
│  │ C1   │ │ C2   │ │ C3   │ │ C4   │ .... │ C40  │        │
│  └──────┘ └──────┘ └──────┘ └──────┘      └──────┘        │
└─────────────────────────────────────────────────────────────┘
                           │
                  ┌────────┴────────┐
                  ▼                 ▼
    ┌─────────────────────┐  ┌──────────────────┐
    │  VERITABANINDA      │  │  DİSK'TE         │
    │  (Meta Veri)        │  │  (Gerçek Veri)   │
    │  • Hash             │  │  • Chunk dosyası │
    │  • Boyut            │  │                  │
    │  • İlişkiler        │  │                  │
    └─────────────────────┘  └──────────────────┘
```

---

## 🗄️ Veritabanı Yapısı

### 1. `chunks` Tablosu (Meta Veri)

Chunk'ların **özellikleri** burada saklanır, **gerçek veri değil**.

```sql
CREATE TABLE chunks (
    hash TEXT PRIMARY KEY,        -- SHA-256 hash (64 karakter)
    size INTEGER NOT NULL,        -- Boyut (byte)
    creation_time INTEGER NOT NULL, -- İlk oluşturulma zamanı
    is_local BOOLEAN NOT NULL     -- Bu cihazda fiziksel olarak var mı?
);
```

**Örnek Kayıt:**
```
hash: 369ef27ecdf158537d176e9211e5753e2356238c3807d49037f832d3e1fb9ec8
size: 262144  (256 KB)
creation_time: 1729261196
is_local: true
```

> 💡 **Önemli:** Bu tabloda sadece chunk'ın **kimliği ve özellikleri** var. Gerçek 256 KB veri burada değil!

---

### 2. `file_chunks` Tablosu (İlişki Tablosu)

Hangi dosyanın hangi chunk'lardan oluştuğunu gösterir.

```sql
CREATE TABLE file_chunks (
    file_id TEXT NOT NULL,        -- Dosya ID'si
    chunk_hash TEXT NOT NULL,     -- Chunk hash'i
    chunk_index INTEGER NOT NULL, -- Dosya içindeki sıra (0, 1, 2...)
    PRIMARY KEY (file_id, chunk_index),
    FOREIGN KEY (file_id) REFERENCES files(id),
    FOREIGN KEY (chunk_hash) REFERENCES chunks(hash)
);
```

**Örnek Kayıtlar:**
```
file_id: test-file-id-123
chunk_hash: 369ef27ecdf158537d176e9211e5753e2356238c3807d49037f832d3e1fb9ec8
chunk_index: 0

file_id: test-file-id-123
chunk_hash: 5e109762ce5dd1041397f443ac4b44cf146af64de5d82385b01e2a6b5ffa27ae8
chunk_index: 1

file_id: test-file-id-123
chunk_hash: 387b19e34428ae0334611e1f7803bb6c4c69358bfcc8030305935046203fc4178
chunk_index: 2

file_id: test-file-id-123
chunk_hash: db8009af28a9ba246f077741fe0800086e20491121ab9891ea0cf243714014c66
chunk_index: 3
```

> 💡 Bu sayede dosyayı yeniden birleştirmek için chunk'ların **sırasını** biliyoruz!

---

## 💾 Disk Depolama (Content-Addressable Storage)

Chunk'ların **gerçek verisi** disk'te saklanır.

### Depolama Yolu:
```
C:\Users\{kullanıcı}\.aether\chunks\
```

### Dosya Adlandırma: Hash Bazlı

Chunk'lar **hash değerleri ile** adlandırılır:

```
.aether/
├── chunks/
│   ├── 369ef27ecdf158537d176e9211e5753e2356238c3807d49037f832d3e1fb9ec8  (256 KB)
│   ├── 5e109762ce5dd1041397f443ac4b44cf146af64de5d82385b01e2a6b5ffa27ae8  (256 KB)
│   ├── 387b19e34428ae0334611e1f7803bb6c4c69358bfcc8030305935046203fc4178  (256 KB)
│   └── db8009af28a9ba246f077741fe0800086e20491121ab9891ea0cf243714014c66  (256 KB)
```

> ⚠️ **Not:** Dosya isimleri uzantısız, sadece hash!

### Content-Addressable Storage Mantığı

```
┌─────────────────────────────────────────────────────────────┐
│  Chunk Verisi                                               │
│  ┌──────────────────────────────────────────────────┐      │
│  │ AETHER_CHUNKING_TEST_AETHER_CHUNKING_TEST_...   │      │
│  └──────────────────────────────────────────────────┘      │
│                        │                                     │
│                        ▼ SHA-256                             │
│  ┌──────────────────────────────────────────────────┐      │
│  │ 369ef27ecdf158537d176e9211e5753e2356238c...     │      │
│  └──────────────────────────────────────────────────┘      │
│                        │                                     │
│                        ▼ Disk'e Yaz                          │
│  📄 .aether/chunks/369ef27ecdf158537d176e9211e5753e... │
└─────────────────────────────────────────────────────────────┘
```

**Neden Hash İsim?**
- ✅ Aynı içerik → Aynı hash → Tek dosya (Deduplication)
- ✅ Veri bütünlüğü: Dosya adı = Dosya içeriği
- ✅ Collision yok (SHA-256 çok güvenli)

---

## 🔄 Deduplication Mekanizması

### Senaryo: Aynı Dosyayı 2 Farklı Klasöre Ekleme

```
┌────────────────────────────────────────────────────────────┐
│  1. Kullanıcı dosyayı ilk kez ekler                        │
│     video.mp4 → Klasör A                                   │
└────────────────────────────────────────────────────────────┘
           │
           ▼ Chunking
┌────────────────────────────────────────────────────────────┐
│  Chunk'lar oluşturulur ve disk'e yazılır:                  │
│  • 369ef27... → .aether/chunks/369ef27... (YENİ)          │
│  • 5e10976... → .aether/chunks/5e10976... (YENİ)          │
│  • 387b19e... → .aether/chunks/387b19e... (YENİ)          │
│  • db8009a... → .aether/chunks/db8009a... (YENİ)          │
└────────────────────────────────────────────────────────────┘
           │
           ▼ Veritabanına Kaydet
┌────────────────────────────────────────────────────────────┐
│  chunks: 4 kayıt                                           │
│  file_chunks: 4 kayıt (file_id = video-a)                 │
└────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════

┌────────────────────────────────────────────────────────────┐
│  2. Kullanıcı AYNI dosyayı tekrar ekler                    │
│     video.mp4 → Klasör B                                   │
└────────────────────────────────────────────────────────────┘
           │
           ▼ Chunking
┌────────────────────────────────────────────────────────────┐
│  Chunk'lar hesaplanır:                                      │
│  • 369ef27... → ZATEN VAR, ATLA! ❌ DİSK YAZMA YOK        │
│  • 5e10976... → ZATEN VAR, ATLA! ❌ DİSK YAZMA YOK        │
│  • 387b19e... → ZATEN VAR, ATLA! ❌ DİSK YAZMA YOK        │
│  • db8009a... → ZATEN VAR, ATLA! ❌ DİSK YAZMA YOK        │
└────────────────────────────────────────────────────────────┘
           │
           ▼ Sadece İlişki Kaydet
┌────────────────────────────────────────────────────────────┐
│  chunks: 4 kayıt (DEĞİŞMEDİ)                              │
│  file_chunks: +4 yeni kayıt (file_id = video-b)           │
│              8 toplam kayıt                                 │
└────────────────────────────────────────────────────────────┘
```

### Sonuç:
```
Disk Kullanımı:
- Olmadan Deduplication: 2 dosya × 1 MB = 2 MB
- Deduplication ile: 1 MB

Tasarruf: 1 MB (%50)
```

---

## 📊 Örnek Senaryo: Gerçek Veriler

### Başlangıç Durumu

**Kullanıcı Dosyası:**
- `test.txt` (1 MB)

**Chunking Sonucu:**

| Chunk Index | Hash                                                         | Boyut    | Disk Yolu                                    |
|-------------|--------------------------------------------------------------|----------|----------------------------------------------|
| 0           | 369ef27ecdf158537d176e9211e5753e2356238c3807d49037f832d... | 256 KB   | `.aether/chunks/369ef27...`                  |
| 1           | 5e109762ce5dd1041397f443ac4b44cf146af64de5d82385b01e2a6b... | 256 KB   | `.aether/chunks/5e10976...`                  |
| 2           | 387b19e34428ae0334611e1f7803bb6c4c69358bfcc8030305935046... | 256 KB   | `.aether/chunks/387b19e...`                  |
| 3           | db8009af28a9ba246f077741fe0800086e20491121ab9891ea0cf243... | 256 KB   | `.aether/chunks/db8009a...`                  |

---

### Veritabanı Kayıtları

#### `chunks` Tablosu:
```sql
SELECT * FROM chunks;
```

| hash          | size    | creation_time | is_local |
|---------------|---------|---------------|----------|
| 369ef27...    | 262144  | 1729261196    | 1        |
| 5e10976...    | 262144  | 1729261196    | 1        |
| 387b19e...    | 262144  | 1729261196    | 1        |
| db8009a...    | 262144  | 1729261196    | 1        |

#### `file_chunks` Tablosu:
```sql
SELECT * FROM file_chunks WHERE file_id = 'test-file-id-123';
```

| file_id           | chunk_hash  | chunk_index |
|-------------------|-------------|-------------|
| test-file-id-123  | 369ef27...  | 0           |
| test-file-id-123  | 5e10976...  | 1           |
| test-file-id-123  | 387b19e...  | 2           |
| test-file-id-123  | db8009a...  | 3           |

---

## 🔍 Dosyayı Yeniden Birleştirme (Reassembly)

```python
# Pseudo-kod
def reassemble_file(file_id):
    # 1. Chunk ilişkilerini al (sıralı)
    file_chunks = SELECT * FROM file_chunks 
                  WHERE file_id = file_id 
                  ORDER BY chunk_index
    
    # 2. Her chunk'ı disk'ten oku
    final_data = []
    for fc in file_chunks:
        chunk_path = f".aether/chunks/{fc.chunk_hash}"
        chunk_data = read_file(chunk_path)  # 256 KB
        final_data.append(chunk_data)
    
    # 3. Birleştir
    complete_file = concatenate(final_data)
    return complete_file
```

---

## 🛡️ Güvenlik ve Bütünlük

### 1. Hash Doğrulaması
```
Disk'ten okunan chunk → SHA-256 hesapla → Hash eşleşti mi?
```

### 2. Global Hash (Dosya Bütünlüğü)
```
Dosya Hash = SHA-256( Chunk1.hash + Chunk2.hash + Chunk3.hash + ... )
```

Bu sayede dosyanın **tüm chunk'larının doğru sırada ve bozulmamış** olduğunu garanti ediyoruz.

---

## ❓ Sık Sorulan Sorular

### Neden chunk'lar veritabanında değil disk'te?

1. **Performans:** SQLite için 256 KB BLOB yazma çok yavaş
2. **Veritabanı boyutu:** 1 GB dosya = 4000+ chunk → veritabanı şişer
3. **Dosya sistemi optimizasyonu:** Modern dosya sistemleri chunk okuma için optimize
4. **Yedekleme kolaylığı:** `.aether/chunks/` klasörünü kolayca yedekle

### Chunk boyutu neden 256 KB?

- ✅ **Deduplication etkinliği:** Küçük değişiklikler tüm dosyayı etkilemez
- ✅ **Network transfer:** P2P için ideal boyut
- ✅ **Disk I/O:** Optimal okuma/yazma boyutu
- ❌ Çok küçük (4 KB): Fazla dosya, yavaş metadata işleme
- ❌ Çok büyük (10 MB): Düşük deduplication, network verimsizliği

### Disk'teki chunk dosyalarını silersem ne olur?

```
is_local = false olur → "Bu chunk remote'ta var" işaretlenir
→ Peer'lardan indirilebilir
```

### Orphan chunk'lar nasıl temizlenir?

```sql
-- Hiçbir dosyaya bağlı olmayan chunk'ları bul ve sil
DELETE FROM chunks
WHERE hash NOT IN (SELECT DISTINCT chunk_hash FROM file_chunks);
```

---

## 📐 Mimari Şema

```
┌───────────────────────────────────────────────────────────────┐
│                    KULLANICI KATMANI                          │
│  Flutter UI → gRPC → Go Backend                               │
└───────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌───────────────────────────────────────────────────────────────┐
│                 USE CASE KATMANI                              │
│  ChunkingUseCase:                                             │
│  • ChunkAndStoreFile()                                        │
│  • LoadFileChunks()                                           │
│  • VerifyFileIntegrity()                                      │
│  • DeleteFileChunks()                                         │
└───────────────────────────────────────────────────────────────┘
                    │              │
        ┌───────────┴──────┐       └──────────────┐
        ▼                  ▼                       ▼
┌──────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   CHUNKER    │  │  CHUNK STORAGE   │  │  CHUNK VERIFIER  │
│ (Algorithm)  │  │   (Disk I/O)     │  │  (SHA-256)       │
└──────────────┘  └──────────────────┘  └──────────────────┘
                           │
                ┌──────────┴─────────┐
                ▼                    ▼
     ┌────────────────────┐   ┌──────────────────┐
     │  SQLite Database   │   │  File System     │
     │  • chunks          │   │  .aether/chunks/ │
     │  • file_chunks     │   │  (Binary files)  │
     └────────────────────┘   └──────────────────┘
```

---

## ✅ Özet

| Katman              | Sorumluluğu                    | Depolama                  |
|---------------------|--------------------------------|---------------------------|
| **Database (chunks)**    | Chunk meta verisi              | Hash, boyut, is_local     |
| **Database (file_chunks)** | Dosya-chunk ilişkileri       | file_id, chunk_hash, index |
| **Disk (.aether/chunks/)** | Gerçek chunk verisi          | Binary dosyalar (256 KB)  |

**Deduplication:** Aynı hash → Tek disk dosyası → Çoklu referans

**Bütünlük:** SHA-256 hash doğrulaması + Global hash

**Performans:** Content-addressable storage + Optimal chunk boyutu

---

🎯 **Sonuç:** Veritabanı "ne var" sorusunu, disk "veri nerede" sorusunu yanıtlıyor!

