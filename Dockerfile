FROM ubuntu:latest

# apt
RUN apt update -y
RUN apt install default-jre -y
RUN apt install openjdk-11-jre-headless -y
RUN apt install curl -y

# directory
RUN mkdir -p /reserve
RUN mkdir -p /bungeecord
RUN mkdir -p /std

# copy config.yml to reserve folder
COPY config.yml /reserve/config.yml

# download bungeecord to reserve folder
RUN curl https://ci.md-5.net/job/BungeeCord/lastStableBuild/artifact/bootstrap/target/BungeeCord.jar -o /reserve/BungeeCord.jar

# start script
COPY bin/start /bin/start
RUN chmod 770 /bin/start

# cmd script
COPY bin/cmd /bin/cmd
RUN chmod 770 /bin/cmd

# stop script
COPY bin/stop /bin/stop
RUN chmod 770 /bin/stop

# warmup script
COPY warmup.sh /warmup.sh
RUN chmod 770 /warmup.sh

# entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 770 /docker-entrypoint.sh

# expose port
EXPOSE 25577/tcp
EXPOSE 25577/udp

# entrypoint
ENTRYPOINT [ "/docker-entrypoint.sh" ]