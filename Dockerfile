FROM mesosphere/mesos-master:0.26.0-0.2.145.ubuntu1404

RUN apt-get install -y \
            curl \
            unzip


### uncomment this for Oracle Java
#RUN curl -L -O -b "oraclelicense=a" \
#      http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz && \
#    tar xfz jdk-8u66-linux-x64.tar.gz && \
#    rm jdk-8u66-linux-x64.tar.gz && \
#    mv jdk1.8.0_66 /opt/java
#ENV JAVA_HOME /opt/java
#ENV PATH $JAVA_HOME/bin:$PATH

ENV LEIN_ROOT 1
RUN curl -o /usr/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x /usr/bin/lein

RUN curl -L -O https://github.com/gonewest818/clj-mesos/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    cd clj-mesos-master && \
    lein install

COPY . /work
WORKDIR /work
RUN mkdir /work/checkouts && ln -s /clj-mesos-master /work/checkouts/clj-mesos

#ENTRYPOINT ["/usr/bin/lein"]
#CMD ["repl", ":headless"]
#EXPOSE 4000
