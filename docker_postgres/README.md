# PostgreSQL with extensions

## Debug

```shell
IMG="qpod/postgres-ext"

docker run -d \
    --name db-postgres \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=pg-password \
    $IMG

ls -alh /usr/share/postgresql/15/extension/*.control
```

```sql
SELECT * FROM pg_extension;
SELECT * FROM pg_available_extensions ORDER BY name;
CREATE EXTENSION "vector";
```
