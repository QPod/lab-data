echo "To install PG extensions: $(cat /opt/utils/install_list_pgext.apt)"
install_apt /opt/utils/install_list_pgext.apt

if [[ ${PG_MAJOR} == "15" ]]; then
    # Fix pgagent for PG 15
    rm -rf /usr/share/postgresql/15/extension/pgagent*
    mv     /usr/share/postgresql/16/extension/pgagent* /usr/share/postgresql/15/extension/    
fi

mv /var/lib/postgresql/extension/* /usr/share/postgresql/${PG_MAJOR}/extension/

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


setup_pgroonga(){
    ## ref1: https://pgroonga.github.io/tutorial/
    ## ref2: https://github.com/pgroonga/docker
    mkdir -pv /tmp/pgroonga && cd /tmp/pgroonga
    wget https://apache.jfrog.io/artifactory/arrow/debian/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
 && apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
 && rm apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
 && wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb \
 && apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb \
 && rm groonga-apt-source-latest-$(lsb_release --codename --short).deb \
 && apt update && apt install -y -V \
    postgresql-${PG_MAJOR}-pgdg-pgroonga groonga-normalizer-mysql groonga-token-filter-stem groonga-tokenizer-mecab
}
setup_pgroonga


setup_pg_net() {
    cd /tmp
    git clone --depth 1 -b master https://github.com/supabase/pg_net
    cd /tmp/pg_net
    apt-get -qq install -yq --no-install-recommends libcurl4-gnutls-dev postgresql-server-dev-${PG_MAJOR}
    make -j8 && make install
}
setup_pg_net


# required to build some extensions
apt-get remove -y postgresql-server-dev-${PG_MAJOR}

ls -alh /usr/share/postgresql/*/extension/*.control | sort
