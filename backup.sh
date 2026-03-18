#!/bin/bash
set -euo pipefail

source .env

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./db-backup"
BACKUP_FILE="$BACKUP_DIR/redmine_$TIMESTAMP.sql.gz"

mkdir -p "$BACKUP_DIR"
chmod 755 "$BACKUP_DIR"

docker exec redmine-db \
  pg_dump -U "${DB_USER:-redmine}" "${DB_NAME:-redmine}" \
  | gzip > "$BACKUP_FILE"

echo "Backup creado: $BACKUP_FILE"

ls -t "$BACKUP_DIR"/*.sql.gz | tail -n +8 | xargs -r rm --

echo "Backups anteriores limpiados."