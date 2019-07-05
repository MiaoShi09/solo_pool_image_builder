FROM ubuntu:18.04


RUN apt-get update \
    && apt install -y build-essential git wget lbzip2 python2.7 python-dev make openssl
RUN groupadd -r pooladm && useradd -r -u 1001 -g pooladm pooladm


RUN echo $HOME \
    && git clone -b patch-jsonrpc https://github.com/aionnetwork/aion_miner.git /home/pooladm/pool \
    && cd /home/pooladm/pool \
    && rm -r aion_reference_miner docs README.md \
    && cd aion_solo_pool

RUN cd /home/pooladm/pool/aion_solo_pool && ls \
    && wget http://download.redis.io/releases/redis-4.0.8.tar.gz \
    && wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz

RUN cd /home/pooladm/pool/aion_solo_pool && tar -xf redis-4.0.8.tar.gz
RUN cd /home/pooladm/pool/aion_solo_pool && tar -xf node-v8.9.4-linux-x64.tar.xz

RUN cd /home/pooladm/pool/aion_solo_pool && chmod 777 -R redis-4.0.8 node-v8.9.4-linux-x64
RUN cd /home/pooladm/pool/aion_solo_pool &&  mv redis-4.0.8 redis && mv node-v8.9.4-linux-x64 node \
    && rm redis-4.0.8.tar.gz node-v8.9.4-linux-x64.tar.xz

USER pooladm





RUN cd /home/pooladm/pool/aion_solo_pool && make -C ./redis

USER root
RUN cd /home/pooladm/pool/aion_solo_pool && export PATH=$PATH:$PWD/node/bin && mkdir /home/pooladm/.npm-global && npm config set prefix /home/pooladm/.npm-global && export PATH=/home/pooladm/.npm-global/bin:${PATH} && npm install -g npm@latest --unsafe-perm &&  npm install --unsafe-perm



WORKDIR /home/pooladm/pool/aion_solo_pool

ADD configs/aion.json  /home/pooladm/pool/aion_solo_pool/pool_configs/aion.json


ENTRYPOINT ["/bin/bash"]
CMD ["./run_quickstart.sh"]

ENV PATH=${PATH}:/home/pooladm/pool/aion_solo_pool/node/bin:/home/pooladm/.npm-global/bin

EXPOSE 3333
