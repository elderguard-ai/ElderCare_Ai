# ElderGuard AI

> Personalized health monitoring and emergency assistance for elderly people who live alone.

Academic prototype: SE5104 Mini Project, Sabaragamuwa University of Sri Lanka (IoTrix 2.0, Track C).

## How it works

1. An **ESP32 wearable** measures heart rate, SpO₂, temperature and motion, and detects falls.
2. It sends the readings over **Bluetooth Low Energy** to a **Flutter app** with Elderly and Caregiver modes.
3. The app relays the data to a **FastAPI + MySQL backend**, which stores the history, runs an explainable **risk engine** (Normal / Warning / High Risk / Critical) and alerts linked caregivers.
4. A **QR code** on the patient's phone opens a read-only hospital summary page.

## System components

| Component | Technology | Folder |
|---|---|---|
| Wearable | ESP32-S3, C++ (PlatformIO) | `firmware/esp32-wearable/` |
| Mobile app | Flutter (Android) | `frontend/` |
| Backend API and risk engine | FastAPI, MySQL, Docker | `backend/` |
| Hospital QR page | FastAPI + Jinja2 | `backend/app/web/` |

## Team

| Member | Module |
|---|---|
| V. Kathirsan (22CSE0401) | IoT wearable and BLE |
| S. Abisegan (22CSE0400) | Backend API and risk engine |
| M. Pavithar (22CSE0393) | Flutter dual-mode app |
| R.M.P.B. Rajaguru (22CSE0370) | Hospital QR web dashboard |

## Branches

| Branch | Purpose |
|---|---|
| `main` | Stable and protected. Changes arrive only through reviewed pull requests. |
| `reference` | Complete reference implementation of the whole system, with setup instructions. |
| `feature/<module>-<task>` | One branch per task, e.g. `feature/backend-risk-engine`. |

See [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow.

## Getting started

The full source code and setup instructions (Docker backend, Flutter app, firmware) are on the [`reference`](../../tree/reference) branch.

## Disclaimer

This is an academic prototype, not a certified medical device. It does not diagnose or treat any condition.
