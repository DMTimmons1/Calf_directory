#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Use this on Render free tier since pre-deploy commands require a paid instance
bundle exec rails db:migrate