```bash
docker build -t qpod0dev/systemd --build-arg "BASE_NAMESPACE=qpod" .

docker run -d --name=tmp_sysd qpod0dev/systemd
docker run -d --name=tmp_sysd --privileged qpod0dev/systemd
```
