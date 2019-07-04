FROM ubuntu:18.04


RUN apt-get update \
    && apt install -y build-essential git wget lbzip2 python2.7 python-dev make openssl \
    && mkdir /pool
RUN git clone -b patch-jsonrpc https://github.com/aionnetwork/aion_miner.git /pool \
    && cd /pool \
    && rm -r aion_reference_miner docs README.md \
    && cd aion_solo_pool

USER root
RUN cd /pool/aion_solo_pool && ls && ./configure.sh


WORKDIR /pool/aion_solo_pool

ADD configs/aion.json  /pool/aion_solo_pool/pool_configs/aion.json


# ENTRYPOINT ["/bin/bash"]
# CMD ["./run_quickstart.sh"]

ENV PATH=${PATH}:/pool/aion_solo_pool/node/bin

EXPOSE 3333
