echo "To install PG extensions: $(cat /opt/utils/install_list_pgext.apt)"
install_apt /opt/utils/install_list_pgext.apt

export USE_PGXS=1

setup_apache_age() {
    cd /tmp
    git clone --depth 1 -b PG${PG_MAJOR} https://github.com/apache/age
    cd /tmp/age
    apt-get -qq install -yq --no-install-recommends flex bison postgresql-server-dev-${PG_MAJOR}
    make -j8 && make install
}
setup_apache_age


# required to build some extensions
apt-get remove -y postgresql-server-dev-${PG_MAJOR}

ls -alh /usr/share/postgresql/*/extension/*.control | sort
