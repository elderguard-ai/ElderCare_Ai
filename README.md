# ElderGuard AI

An AI-powered, IoT-based system for personalized elderly health monitoring and emergency assistance. It has four parts:
- an ESP32 wearable
- a dual-mode Flutter app (Elderly Mode and Caregiver Mode)
- a FastAPI + MySQL backend with a risk engine
- a zero-login hospital QR summary page

> **New to the project? Read [docs/SUMMARY.md](docs/SUMMARY.md) first.** It covers the requirements, the IoT protocol, every API endpoint and the data formats.

```
ElderCare_Ai/
├── backend/                 FastAPI + MySQL (API, risk engine, hospital QR page)
├── frontend/                Flutter mobile app
├── firmware/esp32-wearable/ ESP32 firmware (PlatformIO)
└── docs/SUMMARY.md          project summary
```

## Prerequisites

| Tool | Version |
|---|---|
| Docker Desktop | Recommended for the backend (replaces Python + MySQL below) |
| Python | 3.11+ (only without Docker) |
| MySQL | 8.0+ (only without Docker) |
| Flutter | 3.24+ |
| PlatformIO | For the firmware only |

## 1. Backend

### With Docker (recommended)

Run these from the project root, with Docker Desktop running:

```bash
copy .env.example .env             # macOS/Linux: cp .env.example .env
docker compose up -d --build       # http://localhost:8000/docs
```

- In `.env`, set `PUBLIC_BASE_URL` to this computer's Wi-Fi address and `SECRET_KEY` to a random value.
- On every start, the API container creates or upgrades the tables and loads the demo data, so it is ready for the app straight away.
- The database lives in the `db_data` volume. You can view it in MySQL Workbench on `localhost:3307`.

| Task | Command |
|---|---|
| View logs | `docker compose logs -f api` |
| Stop | `docker compose down` |
| Reset the database | `docker compose down -v` |

### Without Docker

Run these from the `backend/` folder. The commands below are for Windows PowerShell (macOS/Linux equivalents are in comments).

```bash
python -m venv venv
venv\Scripts\activate              # macOS/Linux: source venv/bin/activate
pip install -r requirements-dev.txt
copy .env.example .env             # macOS/Linux: cp .env.example .env
```

Then:
1. Edit `.env`: set `DATABASE_URL` and `SECRET_KEY`.
2. Create the database in MySQL: `CREATE DATABASE elderguard_db;`
3. Run the migrations, load the demo data, and start the server:

```bash
alembic upgrade head               # create/upgrade tables
python -m app.db.seed              # demo data (safe to re-run)
python run.py                      # http://localhost:8000/docs
```

Optional: `pytest` runs the tests against the seeded database.

## 2. Flutter app

Run these from the `frontend/` folder.

```bash
flutter pub get
flutter run -d chrome              # UI testing; wearable is simulated on web
flutter run                        # Android phone: real BLE wearable
```

On a **physical Android phone**, the app must know the Wi-Fi address of the computer running the backend. The phone and computer must be on the same network. There are two ways to set it:

- **In the app (no rebuild):** open **Menu & Settings → Server Address** and enter e.g. `192.168.1.20:8000`. The app saves it and reconnects straight away. Use this at demos on other networks.
- **As the build default:**

  ```bash
  flutter build apk --release --dart-define=API_BASE_URL=http://192.168.1.20:8000/api/v1
  ```

Also set `PUBLIC_BASE_URL` to the same address (in the root `.env` for Docker, or `backend/.env` without Docker), so the hospital QR code opens on other devices.

## 3. Wearable firmware

See [firmware/esp32-wearable/README.md](firmware/esp32-wearable/README.md) for wiring and flashing (`pio run -t upload`).

## Test accounts

| Role | Login | Password |
|---|---|---|
| Elderly (Kamala Perera) | `+94771234567` | `password123` |
| Caregiver (Nimal Perera) | `+94719876543` or `nimal.perera@gmail.com` | `password123` |

Linking code: `EG-8829-KP`

Sign in from the welcome screen (**Already have an account? Sign in**), or register a new account. The app remembers the login until you sign out.

## Disclaimer

ElderGuard AI is an academic decision-support prototype. It is not a medical device and does not provide diagnosis.
