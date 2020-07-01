FROM 192.168.2.133:8022/library/maven:3.6.3-openjdk-8

RUN apt-get update && apt-get install -y --no-install-recommends graphviz fonts-wqy-zenhei && rm -rf /var/lib/apt/lists/*

COPY pom.xml /app/
COPY src /app/src/

ENV MAVEN_CONFIG=/app/.m2
WORKDIR /app
RUN mvn package

# chmod required to ensure any user can run the app
RUN mkdir /app/.m2 && chmod -R a+w /app
EXPOSE 8080
ENV HOME /app
ENV PLANTUML_STATS on
ENV ALLOW_PLANTUML_INCLUDE true

CMD java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war

# To run with debugging enabled instead
#CMD java -Dorg.eclipse.jetty.util.log.class=org.eclipse.jetty.util.log.StdErrLog -Dorg.eclipse.jetty.LEVEL=DEBUG -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war
