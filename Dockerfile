# CPP開発環境を持つdebianイメージ
# CPPはGCCを主に使用しマルチステージビルドでGCCをビルドして構築環境イメージにコピーする。
FROM        kagalpandh/kacpp-gccdev AS builder
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
ENV         GCC_VERSION=11.1.0
ENV         GCC_SRC=gcc-${GCC_VERSION}
ENV         GCC_DEST=gcc-${GCC_VERSION}
ENV         GCC_SRC_FILE=${GCC_DEST}.tar.xz
ENV         GCC_URL="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/${GCC_SRC}/${GCC_SRC_FILE}"
ENV         GCC_HOME=/usr/local/${GCC_DEST}
ENV         PATH=${GCC_HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
COPY        sh/apt-install/  /usr/local/sh/apt-install
# 開発環境インストール
RUN         apt update && \
            /usr/local/sh/system/apt-install.sh install gcc.txt && \
            wget ${GCC_URL} && tar -Jxvf ${GCC_SRC_FILE} && cd ${GCC_SRC} && \
                # GCCに必要なライブラリのダウンロード
                ./contrib/download_prerequisites && \
                # configure時のオプション
                # --enable-languages
                #   コンパイルする言語環境
                # --disable-bootstrap
                #   「3-stage bootstrap build」の無効化
                # --disable-multilib
                #   64bit専用コンパイラとする（64bit環境の場合は指定） 
                ./configure --prefix=/usr/local/${GCC_DEST} --enable-languages="c,c++" \
                    --disable-bootstrap --disable-multilib && \
                make -j 2 && make install  && \
                apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*
FROM        kagalpandh/kacpp-pydev
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         GCC_VERSION=11.1.0
ENV         GCC_SRC=gcc-${GCC_VERSION}
ENV         GCC_DEST=gcc-${GCC_VERSION}
ENV         GCC_HOME=/usr/local/${GCC_DEST}
ENV         PATH=${GCC_HOME}/bin:${PYTHON_HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
COPY        --from=builder /usr/local/${GCC_DEST}/ ${GCC_HOME}
COPY        sh/apt-install/ /usr/local/sh/apt-install
COPY        rcprofile /etc/rc.d
RUN         apt update && \
            /usr/local/sh/system/apt-install.sh install cppdev.txt && \
            /usr/local/sh/system/apt-install.sh install uninstall-gcc.txt && \
            cd /usr/local && ln -s ${GCC_DEST} gcc && \
            echo "/usr/local/gcc/lib64" >>/etc/ld.so.conf && ldconfig && \
            cd ~/ && apt clean && rm -rf /var/lib/apt/lists/*
