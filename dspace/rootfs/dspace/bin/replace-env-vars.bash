#!/usr/bin/env bash
set -e

DSPACE_HOSTNAME=${DSPACE_HOSTNAME:-localhost}
DSPACE_BASEURL=${DSPACE_BASEURL:-http://localhost}

DB_URL=${DB_URL:-jdbc:postgresql://postgres:5432/dspace}
DB_USERNAME=${DB_USERNAME:-dspace}
DB_PASSWORD=${DB_PASSWORD:-dspace}

MAIL_SERVER=${MAIL_SERVER:-smtp.example.com}
MAIL_SERVER_PORT=${MAIL_SERVER_PORT:-465}


DSPACE_CFG=/dspace/config/local.cfg
#DSPACE_CFG=~/local.cfg


echo "Atribuindo variáveis de ambiente definidas em docker-compose.yml..."

sed -i "s|{{DSPACE_HOSTNAME}}|${DSPACE_HOSTNAME}|" ${DSPACE_CFG}
sed -i "s|{{DSPACE_BASEURL}}|${DSPACE_BASEURL}|" ${DSPACE_CFG}
sed -i "s|{{DB_URL}}|${DB_URL}|" ${DSPACE_CFG}
sed -i "s|{{DB_USERNAME}}|${DB_USERNAME}|" ${DSPACE_CFG}
sed -i "s|{{DB_PASSWORD}}|${DB_PASSWORD}|" ${DSPACE_CFG}
sed -i "s|{{MAIL_SERVER}}|${MAIL_SERVER}|" ${DSPACE_CFG}
sed -i "s|{{MAIL_SERVER_USERNAME}}|${MAIL_SERVER_USERNAME}|" ${DSPACE_CFG}
sed -i "s|{{MAIL_SERVER_PASSWORD}}|${MAIL_SERVER_PASSWORD}|" ${DSPACE_CFG}
sed -i "s|{{MAIL_SERVER_PORT}}|${MAIL_SERVER_PORT}|" ${DSPACE_CFG}
sed -i "s|{{MAIL_FROM_ADDRESS}}|${MAIL_FROM_ADDRESS}|" ${DSPACE_CFG}
sed -i "s|{{MAIL_FEEDBACK_RECIPIENT}}|${MAIL_FEEDBACK_RECIPIENT}|" ${DSPACE_CFG}
sed -i "s|{{MAIL_ADMIN}}|${MAIL_ADMIN}|" ${DSPACE_CFG}

echo "Atribuições concluídas"
