# fpv-delivery-packages

Репозиторий дополнительных пакетов, локальных артефактов и зависимостей для установки
платформы гражданской доставки FPV на Debian 13 «trixie». Версионируется независимо от основного
репозитория `fpv-delivery-platform`; основной репозиторий ссылается на конкретный тег
(`fpv_packages_ref` в `deploy/ansible/group_vars/all.yml`, сейчас `v2026.10.1`).

## Состав

| Каталог | Содержимое |
|---|---|
| `debian/trixie/packages.manifest` | системные пакеты Debian 13 по группам узлов с допустимыми версиями |
| `debian/extra/` | внутренние .deb организации (только при наличии законного источника; сейчас пусто) |
| `python/requirements-ansible.txt` | ansible-core 2.21.5 и зависимости — версии и хеши SHA-256 |
| `python/requirements-backend.txt` | зависимости backend — версии и хеши SHA-256 |
| `python/requirements-s3.txt` | необязательные зависимости S3-хранилища (boto3) |
| `python/wheels/` | wheel-пакеты для изолированной сети (формируются `scripts/fetch-wheels.sh`, в git не хранятся) |
| `ansible/collections/` | архивы ansible.posix 2.2.2 и community.postgresql 4.2.0 + `SHA256SUMS` + `PROVENANCE.md` |
| `scripts/` | `verify.sh` (целостность и отсутствие секретов), `fetch-wheels.sh`, `check-debian13.sh` |
| `SHA256SUMS` | контрольные суммы всех файлов репозитория |
| `CHANGELOG.md` | журнал изменений |

Секреты, пароли, ключи, токены, персональные данные и образы с конфиденциальной информацией
в репозиторий не помещаются (проверяется `scripts/verify.sh`).

## Публикация новой версии

1. Обновить манифесты/требования; для Python — `uv pip compile --upgrade --python-version 3.13.5 --generate-hashes`.
2. Проверить совместимость с Debian 13: `scripts/check-debian13.sh` в контейнере `debian:13` с доступом к зеркалу.
3. Пересчитать суммы: `sha256sum` (см. раздел «Контрольные суммы»), выполнить `scripts/verify.sh`.
4. Записать изменения в `CHANGELOG.md`, обновить `VERSION`, создать подписанный тег `vYYYY.MM.N`.
5. В основном репозитории изменить `fpv_packages_ref` и пересобрать комплект.

## Контрольные суммы

```bash
git ls-files | grep -v '^SHA256SUMS$' | sort | xargs sha256sum > SHA256SUMS
scripts/verify.sh
```

## Изолированная сеть

```bash
scripts/fetch-wheels.sh                 # на узле с доступом к PyPI/внутреннему индексу
# каталог python/wheels/ переносится вместе с комплектом; install.sh --offline
# устанавливает только из него (pip --no-index --require-hashes)
```

Пакеты Debian — из внутреннего зеркала ЦОД (`fpv_apt_source: mirror`), см. `debian/README.md`.

## Возврат к предыдущей версии

Основной репозиторий собирает комплект с явным тегом пакетов. Для возврата:
`git checkout v<предыдущая>` в этом репозитории, вернуть `fpv_packages_ref`, пересобрать комплект
(`build-bundle.sh` проверяет совпадение версии и контрольные суммы) и выполнить установку повторно;
журнал установки сохраняется в `/tmp/ancible/logs/` и `/var/log/fpv/ansible/`.
