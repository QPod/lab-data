echo "To install PG extensions: $(cat /opt/utils/install_list_pgext.apt)"
install_apt /opt/utils/install_list_pgext.apt

export USE_PGXS=1

setup_apache_age() {
    cd /tmp
    git clone --depth 1 -b PG15 https://github.com/apache/age
    cd /tmp/age
    apt-get -qq install -yq --no-install-recommends flex bison
    make -j8 && make install
}
setup_apache_age

ls -alh /usr/share/postgresql/*/extension/*.control | sort
