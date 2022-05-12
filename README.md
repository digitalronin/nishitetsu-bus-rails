# Nishitetsu Bus Rails

Rails application to provide a better web/mobile web interface to [Nishitetsu
Bus](https://www.nishitetsu.jp/bus/) services.

## Developing

`make up|down` to start/stop the development environment

`make provision` if you change the Gemfile

`make shell|rails-c` run a terminal or rails console in the running development environment.

### Load reference data

```
make shell
rails runner data/create_bus_stops.rb
rails runner data/create_bus_routes.rb
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

## TODO

- add "return" option to invert a bus route search
- enable changing to/from bus stop from the departures page (i.e. touch to/from to return to the map and select a different stop)
- Use timetable data to figure out all the bus routes (i.e. the order of stops, based on the time of the first bus)
- do something to prevent hitting the heroku hobby database limit (maybe store routes as JSON objects?)
- Initialise the map to user's chosen/current location
- add dynamic search fields for from/to bus stops
- enable user to keep a page of favourite journeys
- enable "express routes only"
- show bus routes in the tooltip for each bus stop
- show material animations in the text fields, when user selects a bus stop
- add materialize-css "properly"
- Add leaflet as an npm package & replace tags in the layout
- add some explanatory text
- make it look nicer
- create tasks to refresh the lookup data
