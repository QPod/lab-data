```bash
docker build -t qpod/gpdb --build-arg "BASE_NAMESPACE=qpod" .

docker run -it \
  -p 15432:5432  -p 10022:22 \
  -v $(pwd):/opt/dev \
  docker.io/qpod/base \
  bash
```
