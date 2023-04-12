#!/bin/bash

set -e

npm install

npm run build

pm2-runtime ./dist/server.js
