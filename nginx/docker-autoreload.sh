#!/bin/sh
###########

while true
do
  inotifywait --exclude .swp -e create -e modify -e delete -e move /etc/nginx/conf.d
  echo "Waiting 5s for additionnal changes"
  sleep 5

  # Test nginx configuration
  nginx -t
  # If it passes, we reload
  if [ $? -eq 0 ]
  then
    echo "Detected Nginx Configuration Change"
    echo "Executing: nginx -s reload"
    nginx -s reload
  else
    echo "Configuration not valid, we do not reload."
  fi
done
