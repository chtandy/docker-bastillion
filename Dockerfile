FROM ubuntu:20.04
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
ENV PATH=$JAVA_HOME/bin:$PATH

RUN apt-get update \
  && apt-get install --assume-yes default-jdk wget \
  && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN wget https://github.com/bastillion-io/Bastillion/releases/download/v3.10.00/bastillion-jetty-v3.10_00.tar.gz \
  && tar -xzvf bastillion-jetty-v3.10_00.tar.gz \
  && rm -f bastillion-jetty-v3.10_00.tar.gz

RUN sed -i -e 's|^dbPassword.*|dbPassword=Bastillion-jetty|' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
COPY bastillion.jceks.source /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/bastillion.jceks
EXPOSE 8443
WORKDIR /Bastillion-jetty
COPY startup.sh .
RUN chmod +x startup.sh
ENTRYPOINT ["./startup.sh"]
