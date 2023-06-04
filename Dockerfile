FROM gradle:7-jdk17 as build

RUN git clone https://github.com/GeyserMC/Geyser &&\
    cd Geyser &&\
    git submodule update --init --recursive &&\
	gradle build

FROM adoptopenjdk/openjdk11:alpine-jre

COPY --from=build ./Geyser/bootstrap/standalone/target /opt/Geyser

ARG UID=1000
ARG GID=1000
RUN adduser --system --shell /bin/false -u $UID -g $GID --home /opt/Geyser geyser

RUN mkdir -v /var/lib/geyser && chown -v -R ${UID}:0 /var/lib/geyser
VOLUME /var/lib/geyser

USER geyser
WORKDIR /var/lib/geyser
EXPOSE 19132/udp
CMD ["java", "-jar", "/opt/Geyser/Geyser.jar"]
