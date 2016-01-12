FROM mesosphere/mesos-master:0.26.0-0.2.145.ubuntu1404

RUN apt-get install -y \
            curl \
            unzip

ENV LEIN_ROOT 1
RUN curl -o /usr/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x /usr/bin/lein

RUN curl -L -O https://github.com/gonewest818/clj-mesos/archive/master.zip && \
    unzip master.zip && \
    cd clj-mesos-master && \
    lein install

#ENTRYPOINT ["/usr/bin/lein"]
#CMD ["repl", ":headless"]
#EXPOSE 4000

COPY . /work
WORKDIR /work
#RUN lein do clean, uberjar
