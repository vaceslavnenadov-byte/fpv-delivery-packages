# Журнал изменений fpv-delivery-packages

## Не выпущено

- `debian/fpv/`: пакеты платформы `fpv-platform` и `fpv-drone-agent` 0.1.0-2 (Debian 13) с `SHA256SUMS`
  для установки через локальный apt-репозиторий.

## v2026.10.1 — 2026-10-13

Переход на Debian 13 «trixie» (решение заказчика от 13.10.2026; Debian 11 снят с поддержки).

* Манифест `debian/trixie/packages.manifest`: Python 3.13, PostgreSQL 17, Samba 4.22, SSSD 2.10,
  nginx 1.26, ffmpeg 7.1, OpenSSH 10; удалён переходный `apt-transport-https`.
* `python/requirements-ansible.txt`: ansible-core 2.21.5, cryptography 50.0.2 — без известных уязвимостей.
* `python/requirements-backend.txt`: FastAPI 0.143.0, Starlette 1.7.0, anyio 4.15.1, pydantic 2.14.1,
  SQLAlchemy 2.0.54, psycopg 3.2.13, uvicorn 0.54.0, websockets 17.2 — без известных уязвимостей.
* `python/requirements-s3.txt`: boto3 1.43, urllib3 2.8 — без известных уязвимостей.
* Коллекции: ansible.posix 2.2.2, community.postgresql 4.2.0 (из ansible 14.5.0, PyPI).
* `scripts/check-debian13.sh` (формат источников deb822), wheels для Python 3.13 и glibc 2.41.

Проверено: офлайн-установка комплекта в контейнере `python:3.13-slim-trixie` (Debian 13).
Не проверено: `check-debian13.sh` против зеркала (нет доступа к deb.debian.org в среде сборки).

## v2026.10.0 — 2026-10-12

Первая версия.

* Манифест пакетов Debian 11 (bullseye) для групп: all, domain_sssd, file_servers, workstations,
  db_servers, app_servers.
* `python/requirements-ansible.txt`: ansible-core 2.15.13 (последняя ветка с поддержкой Python 3.9
  на управляющем узле), зависимости закреплены с хешами.
* `python/requirements-backend.txt`: FastAPI 0.128.8, Starlette 0.49.3, SQLAlchemy 2.0.36, psycopg 3.2.3,
  ldap3 2.9.1, uvicorn 0.34.0 и зависимости, с хешами — последние версии с поддержкой Python 3.9,
  выбранные по результатам pip-audit.
* `python/requirements-s3.txt`: boto3 (необязательно, только для `FPV_OBJECT_STORE=s3`).
* `python/requirements-ansible.txt`: cryptography 50.0.2 (исправления безопасности).
* Известные неустранимые на Python 3.9 уязвимости (anyio, starlette, ansible-core) и оценка их
  применимости — `fpv-delivery-platform/docs/security-review.md`.
* Офлайн-архивы коллекций ansible.posix 1.5.4 и community.postgresql 2.4.3 (из ansible 8.7.0, PyPI).
* Скрипты проверки целостности, загрузки wheels и проверки совместимости с Debian 11.

Проверено: установка комплекта в контейнере `python:3.9-slim-bullseye` (Debian 11) в офлайн-режиме.
Не проверено в этой версии: `check-debian11.sh` против зеркала (в среде сборки не было доступа к deb.debian.org).
