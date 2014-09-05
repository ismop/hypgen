# Hypgen

Hypgen is a tool for generating ISMOP experiments.

## Installation

1. Clone hypgen git repository `export GIT_SSL_NO_VERIFY=1 git clone git@dev.cyfronet.pl:ismop/hypgen.git`. Server certificate needs to be disabled since dice's gitlab  certificate signed by terena is not added to default Ubuntu trusted certs store.
1. Enter `hypgen` directory
1. Intall required gems `bundle install --deployment`
1. Create configuration file:

```
cp config.yml.example config.yml
```

end customize it:

```
editor config.yml
```

## Running

```
bundle exec puma
```

## Usage

Create new experiment

```
curl -H "Content-Type: application/json" -d '{"experiment":{"profile_ids":[1,2,3], "start": "2012-04-23T18:25:43.511Z", "end": "2012-04-23T18:25:43.511Z"}}' -u username:password http://localhost:9292/api/experiments
```

Where `username` and `password` are eqals to values set in `config.yml`

As a result new experiment will be created, new workflow with required dependencies
will be started. Service will response `303` status on success with `Location` header poining to created experiment.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hypgen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
