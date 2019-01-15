FROM openjdk:8-jdk-alpine

ENTRYPOINT [ "sh", "-c", "cd /opt/gatling-fundamentals && chmod 777 gradlew && ./gradlew gatlingRun-simulations.RuntimeParameters -DUSERS=2000 -DRAMP_DURATION=5 -DDURATION=30 && cp /opt/gatling-fundamentals/build/reports/gatling/runtimeparameters* /builds/dast/dockerbuildproject/" ]

WORKDIR /opt

CMD java -XX:+PrintFlagsFinal $JAVA_OPTIONS -jar java-container.jar

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

RUN wget -q https://services.gradle.org/distributions/gradle-3.3-bin.zip  \
    && unzip gradle-3.3-bin.zip -d /opt \
	&& rm gradle-3.3-bin.zip 

RUN echo "$PWD"
		
RUN apk add git
    
RUN git clone https://github.com/TechieTester/gatling-fundamentals.git

RUN git clone https://github.com/TarunKDas2k18/k8sgatling.git && \
    find /opt/gatling-fundamentals  && \
    cp /opt/k8sgatling/RuntimeParameters.scala /opt/gatling-fundamentals/src/gatling/scala/simulations/ && \
	cp /opt/k8sgatling/BaseSimulation.scala /opt/gatling-fundamentals/src/gatling/scala/baseConfig/ && \
	cat /opt/gatling-fundamentals/src/gatling/scala/baseConfig/BaseSimulation.scala && \
	cat /opt/gatling-fundamentals/src/gatling/scala/simulations/RuntimeParameters.scala 
	
RUN cd /opt/gatling-fundamentals  \ 
   &&  chmod 777 gradlew  

ENV GRADLE_HOME /opt/gradle-3.3
ENV PATH $PATH:/opt/gradle-3.3/bin
