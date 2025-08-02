FROM ruby:3.1-bullseye AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    git \
    nginx \
    && gem install bundler

WORKDIR /site

# Write Gemfile with all dependencies
RUN echo "source 'https://rubygems.org'" > Gemfile && \
    echo "gem 'jekyll'" >> Gemfile && \
    echo "gem 'jekyll-theme-cayman'" >> Gemfile && \
    echo "gem 'rake'" >> Gemfile

# Install all gems
RUN bundle install

# Copy your site files (index.md, _config.yml, etc.)
COPY . .

# Build the site
RUN bundle exec jekyll build -d /site/_site

# --- Final stage with nginx ---
FROM nginx:stable-alpine

# Copy built static site
COPY --from=builder /site/_site /usr/share/nginx/html

# Custom nginx config
COPY default.conf /etc/nginx/conf.d/default.conf
