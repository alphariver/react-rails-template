# React Rails Template

## Description
This is the rails template I use for my Rails 5.2 projects.
As an indie hacker, I am continously starting new projects and I always wanted to simplify the process.
This template mainly focuses on integration of React on Rails.
Some resources in this project has been inspired by [mattbricson][] & [damienlethiec][].

## Requirements

This template currently works with:

* Rails 5.2.x
* PostgreSQL

## Installation

*Optional.*

To make this the default Rails application template on your system, create a `~/.railsrc` file with these contents:

```
-d postgresql
-m https://raw.githubusercontent.com/astrocket/react-rails-template/master/template.rb
```

## Usage

This template assumes you will store your project in a remote git repository (e.g. Bitbucket or GitHub) and that you will deploy to staging and production environments. It will prompt you for this information in order to pre-configure your app, so be ready to provide:

1. The git URL of your (freshly created and empty) Bitbucket/GitHub repository
2. The hostname of your production server

To generate a Rails application using this template, pass the `-m` option to `rails new`, like this:

```
rails new blog \
  --skip-coffee \
  --skip-test-unit \
  -d postgresql \
  -m https://raw.githubusercontent.com/astrocket/react-rails-template/master/template.rb
```

*Remember that options must go after the name of the application.* The only database supported by this template is `postgresql`.

If you’ve installed this template as your default (using `~/.railsrc` as described above), then all you have to do is run:

```
rails new blog
```

## What does it do?

The template will perform the following steps:

1. Ask for options you want in this proeject
  > Apply Capistrano ? / Apply Devise ? / Git remote url ? / Add server IP, username, domain, SSL configs ? (if Capistrano) / Apply UI Template ? (Bootstrap or MaterialUI)
2. Generate your application files and directories based on given options.
3. Add useful gems and good configs
4. Create the development databases
5. Commit everything to git
6. Push the project to the remote git repository you specified

## What's included?

#### Base configuration

* Change the default generators config (cf config/initializers/generators.rb)
* Setup React folder structures with some out of box demo using [reactstrap][].
* React specific generator, `rails g react posts index`. See Next section for information.
* Improve the main layout (cf app/views/layouts/application.html.erb) to include webpack in the asset pipeline
* Create a basic home_controller.rb to have something to show when the app launch
* Create a basic HomeIndex.jsx to have something to show when the app launch
* [react-rails][] gem for React integrity on Rails.
* [reactstrap][] npm for base React components. (Option A)
* [material-ui][] npm for base React components. (Option B)
* [bullet][] gem to track N+1 queries. (with config)
* [fast_jsonapi][] gem for json serializer. (with config & example)
* [json-api-normalizer][] npm for json normaliazer. (with example)
* [rails_erd][] gem to generate automatically a schema of our database relationships. (with config)
* [better-errors][] and [xray-rails][] gem for easier debugging
* [awesome-print][] and [table-print][] for easier exploration in the terminal

#### Optional configuration

* [devise][] can be added and configured directly using react

## React generator

I have added react specific generator task.

with `rails g react posts index`

It generates

* `app/javascript/components/pages/Index.js` with simple rendered props as json.
* Custom JSON viewer is setted for development environment. (You can disable it from javascript/components/commons/App.js)
* Create `posts_controller.rb` if not present.
* Add render helpers to matching index action of posts controller.

## Deployment Procedure

1. modify your database.production.yml
```yml
default: &default
  adapter: postgresql
  encoding: utf8
  # For details on connection pooling, see Rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5

production:
  <<: *default
  host: localhost
  database: blog_production
  username: postgres
  password: <%= Rails.application.credentials.database_password %>
```

2. Add database_password credential from your favorite editor. (ex. nano)
```bash
EDITOR=nano rails credentials:edit
```

3. Go to your remote server and create `blog_production` database.
```bash
sudo -i -u postgres
createdb blog_production
```

3-1. Get SSL certificate from Let's encrypt if you added SSL option.
```bash
git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt
./letsencrypt-auto --help
sudo service nginx stop
./letsencrypt-auto certonly --standalone -d yoursite.com
```

> debug : Command /opt/eff.org/certbot/venv/bin/python2.7 - setuptools pkg_resources pip
> ```bash
> sudo apt-get install letsencrypt
> nano /etc/default/locale
> #  Paste below 4 lines.
> LANG="en_US.UTF-8"
> LC_CTYPE="en_US.UTF-8"
> LC_ALL="en_US.UTF-8"
> LANGUAGE="en_US.UTF-8"
> ```

> debug : Problem binding to port 80: Could not bind to IPv4 or IPv6
> ```bash
> sudo service nginx stop
> ```

4. Deploy !
```bash
cap production doctor
cap production deploy:check
cap production deploy
```

## Todo
* Automate SSL cerficate generation.
* Automate Capistrano production database creation.
* Rewrite devise view layers into React component.

[mattbricson]: https://github.com/mattbrictson/rails-template
[damienlethiec]: https://github.com/damienlethiec/modern-rails-template
[react-rails]: https://github.com/reactjs/react-rails
[reactstrap]: https://github.com/reactstrap/reactstrap
[material-ui]: https://github.com/mui-org/material-ui
[bullet]: https://github.com/flyerhzm/bullet
[fast_jsonapi]: https://github.com/Netflix/fast_jsonapi
[json-api-normalizer]: https://github.com/yury-dymov/json-api-normalizer
[rails_erd]: https://github.com/voormedia/rails-erd
[better-errors]: https://github.com/charliesome/better_errors
[xray-rails]: https://github.com/brentd/xray-rails
[awesome-print]: https://github.com/michaeldv/awesome_print
[table-print]: https://github.com/arches/table_print
[devise]: https://github.com/plataformatec/devise
