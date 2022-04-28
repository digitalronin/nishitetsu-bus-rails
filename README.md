# Nishitetsu Bus Rails

Rails application to provide a better web/mobile web interface to [Nishitetsu
Bus](https://www.nishitetsu.jp/bus/) services.

## Developing

`make up|down` to start/stop the development environment

`make provision` if you change the Gemfile

`make shell|rails-c` run a terminal or rails console in the running development environment.

## Heroku Setup

Generate a secret key base:

```
make shell
rails secret
```

Copy that value for use as the SECRET_KEY_BASE value

```
heroku apps:create nishibus
heroku stack:set container
heroku addons:create heroku-redis:hobby-dev -a nishibus
heroku addons:create heroku-postgresql:hobby-dev -a nishibus
heroku config:set SECRET_KEY_BASE=[value from rails secret]
```

### Heroku Deployment

```
git push heroku main
```
