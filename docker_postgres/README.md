# PostgreSQL with extensions

## Debug

```shell
BUILDKIT_PROGRESS=plain docker build -t postgres-ext -f ./postgres-ext.Dockerfile --build-arg BASE_NAMESPACE=qpod0dev .

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

## Reference

- article: https://mp.weixin.qq.com/s/CduvvvuUDjqNtvKA1OblAQ
- code: https://github.com/digoal/postgresql_docker_builder/blob/main/pg14_amd64/1.sh
