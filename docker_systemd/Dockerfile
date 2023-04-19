# Distributed under the terms of the Modified BSD License.
ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} AS builder

COPY rootfs /

RUN source /opt/utils/script-utils.sh \
 && install_apt /opt/utils/install_list_systemd.apt \
 && rm -f /lib/systemd/system/systemd*udev* \
 && rm -f /lib/systemd/system/getty.target \
 && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
 && chmod +x /*.sh \
 && echo "Clean up" && list_installed_packages && install__clean

# ref: https://cloud-atlas.readthedocs.io/zh_CN/latest/docker/init/docker_systemd.html
ENTRYPOINT [ "/usr/lib/systemd/systemd" ]
CMD [ "log-level=info", "unit=sysinit.target" ]
