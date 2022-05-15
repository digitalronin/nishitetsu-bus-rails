# Nishitetsu Bus Rails

Rails application to provide a better web/mobile web interface to [Nishitetsu
Bus](https://www.nishitetsu.jp/bus/) services.

View this app [on Heroku](https://nishibus.herokuapp.com)

## Developing

`make up|down` to start/stop the development environment

`make provision` if you change the Gemfile

`make shell|rails-c` run a terminal or rails console in the running development environment.

### Load reference data

```
make load-reference-data
```

## Heroku Setup

```
heroku apps:create nishibus
heroku stack:set container
heroku addons:create heroku-redis:hobby-dev -a nishibus
heroku addons:create heroku-postgresql:hobby-dev -a nishibus
```

Set up production credentials:

1. Generate a random string, 32 characters long. This is the `master key`. Store it in `.env`

2. Set the `secret_key_base` in the production credentials file:

```
make shell
. .env
rails credentials:edit --environment production
```

Edit the file and add this line:

```
secret_key_base: [value from rails secret]
```

Save the file and commit it.

```
. .env
heroku config:set RAILS_MASTER_KEY=$RAILS_MASTER_KEY
```

### Heroku Deployment

```
git push heroku main
```

> After first deployment, you will need to load the reference data on the
> Heroku database:

```
heroku run rails runner data/create_bus_stops.rb
heroku run rails runner data/create_bus_routes.rb
```
