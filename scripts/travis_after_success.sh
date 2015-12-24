#!/bin/bash

# submit coverage to coveralls
# cat ./test/coverage/Firefox*/lcov.info | ./node_modules/coveralls/bin/coveralls.js

# push docs on master branch
if [[ $TRAVIS_PULL_REQUEST == false && $TRAVIS_BRANCH == "master" ]]
then
    echo "-- will push docs --"

    git config --global user.email "travis@travis-ci.com"
    git config --global user.name "Travis Bot"

    git clone https://${GHREPO}.git travis_docs_build
    cd travis_docs_build
    git checkout gh-pages

    echo "https://${GHTOKEN}:@github.com" > .git/credentials
    git config credential.helper "store --file=.git/credentials"

    rm -rf ./*
    cp -r ../*.* .
    cp -r ../blue/ blue/
    cp -r ../red/ red/
    cp -r ../yellow/ yellow/
    cp -r ../green/ green/
    cp -r ../editor/ editor/
    cp -r ../theme/ theme/
    npm install --production

    git add -A
    git add -f node_modules
    git add -f **/index.js

    git commit -m "autocommit docs"
    git push origin gh-pages
else
    echo "-- will only push docs from master --"
fi
