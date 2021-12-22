#!/usr/bin/env bash

source .env

if [ -z ${RUBY_VERSION} ] || [ -z ${NODE_VERSION} ] || [ -z ${GIT_USER_NAME} ] || [ -z ${GIT_USER_EMAIL} ]; then
  echo 'Need to edit .env.'
  exit 1
fi

rbenv local ${RUBY_VERSION}
nodenv local ${NODE_VERSION}

git init
git config --local user.name ${GIT_USER_NAME}
git config --local user.email ${GIT_USER_EMAIL}

bundle config set --local without 'production'
bundle config --local build.mysql2 '--with-ldflags=-L/usr/local/opt/openssl/lib'
bundle install --jobs=2

if [ ! -e config.ru ]; then
  PROJECT_NAME=${PROJECT_NAME} bundle exec rails new . -m ./template.rb --skip-git --skip-action-text --skip-asset-pipeline --skip-javascript --skip-hotwire --skip-jbuilder --skip-test --skip-system-test -d mysql -f
else
  PROJECT_NAME=${PROJECT_NAME} bin/rails app:template LOCATION=./template.rb
fi
