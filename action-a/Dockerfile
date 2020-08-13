FROM nimlang/nim as nimbuilder

RUN apt-get install -y musl-tools

# RUN nimble install -y jester uuids

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# WORKDIR /build
# COPY exercism_local_tooling_webserver.nim .
ENTRYPOINT [ "/entrypoint.sh" ]