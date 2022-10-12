# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="atom"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

ENV CONDA_PREFIX=/opt/conda
ENV JAVA_HOME=/opt/jdk
ENV PATH=$PATH:${CONDA_PREFIX}/bin:${JAVA_HOME}/bin

RUN source /opt/utils/script-setup.sh \
 && install_apt /opt/utils/install_list_base.apt \
 && echo "Install tini" && setup_tini \
 # pyflink does not yet support Python > 3.8
 && echo "Install Mamba, Python 3.8, and Conda:" && setup_mamba && setup_conda_with_mamba "3.8" \
 && echo "Install JDK:" && VERSION_JDK=11 setup_java_base \
 && echo "Install pyflink:" && install_pip /opt/utils/list_install_pip_pyflink.txt \
 && echo "Install pyspark:" && install_pip /opt/utils/list_install_pip_pyspark.txt \
 && echo "Clean up" && list_installed_packages && install__clean
