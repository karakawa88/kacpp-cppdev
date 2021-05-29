# CPP開発環境Dockerイメージ

## 概要
CPP開発環境のDockerイメージ。
主にGCCをインストールしている。
debian:buster-slimイメージを基に作成されている。

## 使い方
```shell
docker image pull kagalpandh/kacpp-cppdev
docker run -dit --name kacpp-cppdev kagalpandh/kacpp-cppdev
```

## 説明
GCCをソースからインストールしてある。
インストール場所は/usr/local/gcc-{GCC_VERSION}である。
そのためPATHをここにとうしld.so.confにライブラリを追加している。


##構成
${GCC_HOME}:        /usr/local/gcc-${GCC_VERSION}
${GCC_HOME}/bin:    GCCプログラム
${GCC__HOME}/lib64:  GCCライブラリ

##ベースイメージ
kagalpandh/kacpp-pydev

# その他
DockerHub: [kagalpandh/kacpp-ja](https://hub.docker.com/repository/docker/kagalpandh/kacpp-cppdev)<br />
GitHub: [karakawa88/kacpp-ja](https://github.com/karakawa88/kacpp-cppdev)

