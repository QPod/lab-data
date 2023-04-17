```bash
docker run -it \
  -p 15432:5432  -p 10022:22 \
  -v $(pwd):/opt/dev \
  maven.paic.com.cn:8084/docker.io/qpod/base \
  bash
```