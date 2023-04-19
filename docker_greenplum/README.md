```bash
docker build -t qpod0dev/greenplum --build-arg "BASE_NAMESPACE=qpod" .

docker run -it \
  -p 15432:5432  -p 10022:22 \
  -v $(pwd):/data/gpdb \
  -h gpdb-cdw \
  --name gpdb-cdw \
  docker.io/qpod0dev/greenplum \
  bash

docker run -d \
  -p 15432:5432  -p 10022:22 \
  -v $(pwd):/data/gpdb \
  -h gpdb-cdw \
  --name gpdb-cdw \
  docker.io/qpod0dev/greenplum
```
