```bash
docker build -t qpod0dev/greenplum --build-arg "BASE_NAMESPACE=qpod" .

docker run -it \
  -p 15432:5432  -p 10022:22 \
  -v /data/database/gpdb:/data/gpdb \
  -h gpdb-cdw \
  --name gpdb-cdw \
  docker.io/qpod0dev/greenplum \
  bash

docker run -d \
  -p 15432:5432  -p 10022:22 \
  -v /data/database/gpdb:/data/gpdb \
  -h gpdb-cdw \
  --name gpdb-cdw \
  docker.io/qpod0dev/greenplum

/bin/bash -c ${GPHOME}/entrypoint.sh
```
