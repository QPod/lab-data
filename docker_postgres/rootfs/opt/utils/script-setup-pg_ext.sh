export USE_PGXS=1

setup_apache_age() {
    cd /tmp
    git clone --depth 1 -b PG15 https://github.com/apache/age
    cd /tmp/age
    make -j8 && make install
}


setup_apache_age
