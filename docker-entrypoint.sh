#!/usr/bin/env bash

# copy reserve to bungeecord
cp /reserve/BungeeCord.jar /bungeecord/BungeeCord.jar
cp /reserve/config.yml /bungeecord/config.yml

# create stdin file
echo -n > "/std/bungeecord.stdin"
chmod 770 /std/bungeecord.stdin

# execute warmup script
chmod 770 /warmup.sh
/warmup.sh

# start server
echo "starting server..."
/bin/start &

stop_handler() {
  BUNGEECORD_PID=$(</bungeecord.pid)  
  echo "SIGTERM DETECTED"
  /bin/cmd "end"
  tail --pid=$BUNGEECORD_PID -f /dev/null
  echo "SIGTERM COMPLETE"
}

trap 'stop_handler' SIGTERM

sleep 1
BUNGEECORD_PID=$(</bungeecord.pid)

while true
do
  if [[ -e /proc/${BUNGEECORD_PID} ]]; then
    ( tail --pid=$BUNGEECORD_PID -f /dev/null ) &
    wait ${!}
  else
    break
  fi
done

echo "SERVER STOPPED"
exit 0;