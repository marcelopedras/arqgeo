# comando para limpar e depois restaurar a base de dados
pg_restore --host localhost --port 5432 --username postgres --dbname dspace -c backup-20-10-2019

# comando para fazer o backup
# entrar no docker postgres
docker-compose exec postgres bash
pg_dump --host localhost --port 5432 --username postgres --format tar --file /dspace/database_backups/<nome do arquivo> dspace
# No host o arquivo estará em ./database_backups