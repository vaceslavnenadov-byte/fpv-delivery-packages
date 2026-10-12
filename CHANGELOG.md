# Журнал изменений fpv-delivery-packages

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
