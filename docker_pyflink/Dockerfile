# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="atom"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

ENV CONDA_PREFIX=/opt/conda/ \
    JAVA_HOME=/opt/jdk \
    PATH=/opt/conda/bin:/opt/jkd/bin:$PATH

RUN source /opt/utils/script-setup.sh \
 && install_apt /opt/utils/install_list_base.apt \
 && echo "Install tini" \
 && setup_tini \
 && echo "Install Mamba, Python 3.8, and Conda:" \
 && mkdir -pv ${CONDA_PREFIX} \
 && setup_mamba && setup_conda_with_mamba "3.8" && install__clean \
 && ln -sf /opt/conda/bin/python3 /usr/bin/python \
 && echo "Install JDK:" \
 && setup_java_base && export JAVA_HOME="/opt/jdk" \
 && echo "Install pyflink, and do some updates to packages:" \
 && pip install -U apache-flink \
 && install_pip /opt/utils/list_install_pip_pyflink.txt \
 && echo "Clean up" \
 && list_installed_packages && install__clean
