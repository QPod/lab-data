source /opt/utils/script-utils.sh


setup_postgresql_client() {
  local VER_PG=${VERSION_PG:-"14"}
  # from: https://www.postgresql.org/download/linux/ubuntu/
  echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  # will download ~9MB files and use ~55MB disk after installation
  sudo apt-get -y install "postgresql-client-${VER_PG}"
  echo "@ Version of psql:" && psql --version
}
