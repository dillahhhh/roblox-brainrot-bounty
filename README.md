# 🥚 PASAR TELUR BRAINROT (Roblox Egg Simulator)

> **Bounty Entry for make.fun:** `roblox-brainrot-01` ("Make the best AI Roblox brainrot game")  
> **Cost to Build:** Rp 0,- (100% GRATIS, Tanpa Robux, Menggunakan Asset Bawaan & Toolbox Resmi)

---

## 📖 Ringkasan Konsep Game
Game simulasi dan gacha berbasis **8 Base Player Simetris** dan **Pasar Tengah Terbuka** (1 Map Open-World Seamless, Tanpa Portal):
1. **8 Base Player:** Tiap pemain yang masuk server otomatis mendapatkan kapling base pribadi.
2. **Lapak Telur Brainrot:** Pemain membeli berbagai tier telur di pasar tengah (Telur Ohio, Telur Rizz, Telur Skibidi, Telur Sigma Divine).
3. **Pajangan Pedestal:** Pet Brainrot yang menetas ditaruh di stand base untuk menghasilkan *Passive Income* (Koin/detik).
4. **Peti Pasar Gratis:** Peti harta karun di tengah plaza yang muncul kembali setiap 45 detik untuk dipukul bersama-sama sebagai sumber koin awal gratis.
5. **Rebirth & Upgrade:** Meningkatkan multiplier keberuntungan gacha telur dan kecepatan menetas.

---

## 📂 Struktur Project
```
roblox-brainrot-bounty/
├── default.project.json      # Konfigurasi Rojo untuk sync langsung ke Roblox Studio
├── README.md                 # Dokumentasi & panduan setup lengkap
└── src/
    ├── shared/
    │   └── EggConfig.luau    # Konfigurasi harga telur, drop rate %, dan stat pet
    └── server/
        ├── EconomyService.luau  # Sistem Koin, Gems, Rebirth, DataStore auto-save
        ├── PlotManager.luau     # Sistem auto-claim 8 base simetris
        ├── EggService.luau      # Logika gacha telur & inventaris pemain
        ├── PedestalService.luau # Sistem pajang pet di base & passive income
        └── MarketChest.luau     # Peti harta karun respawn di pasar tengah
```

---

## 🛠️ Cara Setup di Roblox Studio (100% GRATIS)

### Langkah 1: Siapkan Struktur Map di Workspace
Buat objek-objek berikut di dalam **Workspace** menggunakan Part biasa (0 Robux):
1. Buat **Folder** bernama `Plots`:
   - Di dalamnya buat 8 Model bernama `Base1`, `Base2`, ..., sampai `Base8`.
   - Di dalam tiap `Base`, buat 1 Part bernama `SpawnPoint` dan 1 Part bernama `Sign` (berisi SurfaceGui > TextLabel).
   - Di dalam tiap `Base`, buat folder `Pedestals` berisi `Stand1`, `Stand2`, `Stand3`.
2. Di tengah map, buat lantai Plaza (Pasar Tengah) tempat lapak telur dan peti pasar.

### Langkah 2: Masukkan Script ke Roblox Studio
- Copy isi `src/shared/EggConfig.luau` ke **ReplicatedStorage** (buat ModuleScript bernama `EggConfig`).
- Copy semua file di `src/server/` ke **ServerScriptService**:
  - `EconomyService` (Script)
  - `PlotManager` (Script)
  - `EggService` (Script)
  - `PedestalService` (Script)
  - `MarketChest` (Script)

### Langkah 3: Asset Model (Toolbox Gratisan)
Buka tab **Toolbox** di Roblox Studio dan cari model gratis (0 Robux):
- `Egg Stand` / `Market Stall` (Lapak pasar)
- `Skibidi Toilet`, `GigaChad`, `Capybara` (Model pajangan)
- `Indonesian Temple / Candi Joglo` (Dekorasi gapura nusantara)

---

## 🏆 Kesiapan Submission make.fun
Project ini memenuhi seluruh parameter bounty `roblox-brainrot-01`:
* Gameplay loop lengkap (Farming -> Gacha Telur -> Pajang di Base -> Rebirth)
* Arsitektur kode modular Luau standar industri
* 100% bebas biaya pengembangan
