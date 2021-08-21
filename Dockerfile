FROM nvcr.io/nvidia/pytorch:21.07-py3

ENV DEBIAN_FRONTEND noninteractive

RUN wget https://github.com/ku-nlp/jumanpp/releases/download/v2.0.0-rc3/jumanpp-2.0.0-rc3.tar.xz \
    && tar xf jumanpp-2.0.0-rc3.tar.xz \
    && cd jumanpp-2.0.0-rc3 \
    && mkdir bld \
    && cd bld \
    && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/ \
    && make \
    && make install

RUN wget https://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2 \
    && tar jxvf juman-7.01.tar.bz2 \
    && cd juman-7.01 \
    && ./configure --prefix=/usr/local/ \
    && make \
    && make install \
    && apt-get update \
    && apt-get install libjuman

RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.20.tar.bz2 \
    && tar jxvf knp-4.20.tar.bz2 \
    && cd knp-4.20 \
    && ./configure --prefix=/usr/local/ --with-juman-prefix=/usr/local/ \
    && make \
    && make install

RUN echo "alias juman='juman -r /usr/local/etc/jumanrc'" >> ~/.bashrc \
    && source ~/.bashrc

RUN pip install pyknp

RUN rm -rf /workspace/juman* \
    && rm -rf /workspace/knp*