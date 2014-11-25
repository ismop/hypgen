# Hypgen [![Build Status](https://travis-ci.org/ismop/hypgen.svg)](https://travis-ci.org/ismop/hypgen) [![Code Climate](https://codeclimate.com/github/ismop/hypgen/badges/gpa.svg)](https://codeclimate.com/github/ismop/hypgen) [![Test Coverage](https://codeclimate.com/github/ismop/hypgen/badges/coverage.svg)](https://codeclimate.com/github/ismop/hypgen) [![Dependency Status](https://gemnasium.com/ismop/hypgen.svg)](https://gemnasium.com/ismop/hypgen)

Hypgen is a tool for generating ISMOP experiments.

## Installation

1. Clone hypgen git repository `git clone https://github.com/ismop/hypgen.git`. Server certificate needs to be disabled since dice's gitlab  certificate signed by terena is not added to default Ubuntu trusted certs store.
1. Enter `hypgen` directory
1. Intall required gems `bundle install --deployment`
1. Install redis `sudo apt-get install redis-server`
1. install foreman `gem install foreman`
1. Create configuration file:

```
cp config.yml.example config.yml
```

end customize it:

```
editor config.yml
```

## Running

To start both web frontend and worker type:

```
foreman start
```

To start only web frontend type:

```
export HFLOW_PATH=/path/to/hyperflow/
```

```
foreman start web
# or
# bundle exec puma
```

To start only worker type:

```
foreman start worker
# or
# bundle exec ./bin/hypgen-worker
```

## Usage

Create new experiment

```
curl -k -H "Content-Type: application/json" -d '{"experiment":{"name": "exp name", "profile_ids":[1,2], "start_date": "2014-11-21T09:45:42.025Z
", "end_date": "2014-11-22T09:45:42.025Z"}}' -u username:password http://localhost:9292/api/experiments
```

Where `username` and `password` are eqals to values set in `config.yml`

As a result new experiment will be created, new workflow with required dependencies
will be started. Service will response `303` status on success with `Location` header poining to created experiment.

## Contributing

1. Fork it (https://gitlab.dev.cyfronet.pl/ismop/hypgen.git)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
