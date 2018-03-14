#!/bin/bash

DIR=/docker-entrypoint.d

if [ -d $DIR ]
then
  cd $DIR; for f in *; do mv $f $(echo ${f%*.*}); done; cd -
  /bin/run-parts --verbose $DIR
fi

echo "$@"
exec "$@"
