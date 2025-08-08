FROM ruby:2.2.10

# point Jessie at the Debian archive
RUN printf "deb [trusted=yes] http://archive.debian.org/debian jessie main\n" > /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# OS deps + Node (ExecJS runtime for Rails 4 assets)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      tzdata \
      ca-certificates \
      curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://nodejs.org/dist/v16.20.0/node-v16.20.0-linux-x64.tar.xz \
       | tar -xJ -C /usr/local --strip-components=1

WORKDIR /app

# ---- Set env BEFORE bundling ----
ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    BUNDLE_WITHOUT="development:test"

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v "1.16.1" && \
    bundle _1.16.1_ config without "$BUNDLE_WITHOUT" && \
    bundle _1.16.1_ install --jobs 4 --retry 3

# App code
COPY . .

# (Optional) document the local port
EXPOSE 3000

# Bind to Render's $PORT with a local default
CMD ["bash","-lc","bundle _1.16.1_ exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]
