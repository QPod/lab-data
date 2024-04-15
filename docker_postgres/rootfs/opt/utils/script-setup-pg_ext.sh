echo "To install PG extensions: $(cat /opt/utils/install_list_pgext.apt)"
install_apt /opt/utils/install_list_pgext.apt

# Fix pgagent for PG 15
rm -rf /usr/share/postgresql/15/extension/pgagent*
mv     /usr/share/postgresql/16/extension/pgagent* /usr/share/postgresql/15/extension/

## remove un-used PG versions and extensions
find /usr/lib/postgresql   -mindepth 1 -maxdepth 1 -type d -not -name "${PG_MAJOR}" -not -name "lib" -exec rm -rf {} \;
find /usr/share/postgresql -mindepth 1 -maxdepth 1 -type d -not -name "${PG_MAJOR}" -exec rm -rf {} \;

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
