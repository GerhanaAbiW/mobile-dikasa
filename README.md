# Mobile Dikasa

Project kasir F&B berbasis Flutter untuk mendukung alur operasional seperti splash, login, katalog produk, order pelanggan, pembayaran, laporan, notifikasi, dan pengaturan.

## Current Scope

- Splash screen
- Login page (MVVM, terhubung ke lapisan data)
- Order page — katalog produk, keranjang pesanan, dan dialog Kas Awal
- Struktur assets terpusat di `assets/`
- Template PR GitHub dan template MR GitLab untuk workflow review

Tampilan Login dan Order mengikuti desain Figma pada
`DIKASA MOBILE APP/FIGMA` (`Login Page` dan `Order - Clean`),
dirancang untuk tablet landscape 1340x800.

## Arsitektur

Project ini memakai MVVM dengan MobX sebagai state management dan Dio sebagai HTTP client.

```
View  ->  ViewModel  ->  Repository  ->  Service  ->  API
```

| Lapisan | Lokasi | Tanggung jawab |
| --- | --- | --- |
| View | `lib/features/*/view.dart` | Menggambar UI dan navigasi |
| Widget | `lib/features/*/widgets/` | Bagian UI milik satu halaman |
| ViewModel | `lib/features/*/view_model.dart` | State halaman (MobX store) |
| Repository | `lib/data/repositories/` | Sumber kebenaran tunggal, cache, session |
| Service | `lib/data/services/` | Panggilan HTTP lewat Dio |
| Model | `lib/data/models/` | Bentuk data dan parsing JSON |

## Menjalankan Project

```bash
cp .env.example .env
flutter pub get
dart run build_runner build
flutter run
```

Backend belum tersedia, sehingga request dilayani data tiruan
(`lib/core/network/mock_api_interceptor.dart`). Kredensial demo:

- Username: `admin`
- Password: `dikasa123`

Begitu backend siap, set `USE_MOCK_API=false` di `.env`. Tidak ada kode
Service yang perlu diubah.

## Testing

```bash
flutter analyze
flutter test
```
