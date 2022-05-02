#!/bin/bash

PROJECT_DIR=/home/gannit/IdeaProjects/revenue-sharing-contract
cd $PROJECT_DIR

cabal run -- oracle-pab \
  --config testnet/pab-config.yml webserver \
  --passphrase rsc123456789
