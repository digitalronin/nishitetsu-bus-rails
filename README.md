# Nishitetsu Bus Rails

Rails application to provide a better web/mobile web interface to [Nishitetsu
Bus](https://www.nishitetsu.jp/bus/) services.

## Developing

`make up|down` to start/stop the development environment

`make provision` if you change the Gemfile

`make shell|rails-c` run a terminal or rails console in the running development environment.

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

## TODO

- preserve marker colours when user changes map zoom level
- add materialize-css "properly"
- show material animations in the text fields, when user selects a bus stop
- add dynamic search fields for from/to bus stops
- Hide all bus stops not connected to the from stop, when user sets from
- Use a random value to separate my journey from others, so people don't interfere with each others' maps
- Make the map page look nicer - the search function at the top looks bad
- Initialise the map to user's chosen/current location
- Add leaflet as an npm package & replace tags in the layout
