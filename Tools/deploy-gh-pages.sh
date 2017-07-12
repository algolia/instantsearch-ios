#!/bin/bash

cd ../docgen
NODE_ENV='production' npm run build
cd ..
jazzy --clean
gh-pages -d docs