#!/bin/bash

cd ../docgen
yarn build
cd ..
jazzy --clean
cd docs
surge --domain http://instantsearch-ios-docs.surge.sh/ --project ../docs 