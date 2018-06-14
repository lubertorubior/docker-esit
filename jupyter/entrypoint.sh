#!/bin/bash

DIR=/docker-entrypoint.d

if [ -d $DIR ]
then
  cd $DIR; for f in *; do mv $f $(echo ${f%*.*}); done; cd -
  /bin/run-parts --verbose $DIR
fi

if [ $# -eq 0 ]; then
  exec jupyter notebook --notebook-dir=/notebooks --ip='*' --port=8888 --no-browser --allow-root
fi

if [ "$1" = 'jupyterlab' ]; then
  exec jupyter lab --notebook-dir=/notebooks --ip='*' --port=8888 --no-browser --allow-root
elif [ "$1" = 'jupyter' ]; then
  exec jupyter notebook --notebook-dir=/notebooks --ip='*' --port=8888 --no-browser --allow-root
else
  exec "$@"
fi
