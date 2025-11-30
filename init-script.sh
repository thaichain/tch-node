#!/bin/sh

geth --state.scheme=path --db.engine=pebble --datadir /data/geth  init /config/genesis.json

exec geth "$@"
