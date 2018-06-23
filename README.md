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
--webpack=react
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
  --webpack=react \
  -d postgresql \
  -T \
  -m https://raw.githubusercontent.com/astrocket/react-rails-template/master/template.rb
```

*Remember that options must go after the name of the application.* The only database supported by this template is `postgresql`.

If you’ve installed this template as your default (using `~/.railsrc` as described above), then all you have to do is run:

```
rails new blog
```

## What does it do?

The template will perform the following steps:

1. Ask for which option you want in this proeject
2. Generate your application files and directories
3. Add userful gems and good configs
4. Create the development databases
5. Commit everything to git
6. Push the project to the remote git repository you specified

## What's included?

#### Base configuration

* Change the default generators config (cf config/initializers/generators.rb)
* Setup I18n for English and Korean
* Setup React folder structures with some out of box demo using [reactstrap][].
* React specific generator, `rails g react posts`. See Next section for information.
* Improve the main layout (cf app/views/layouts/application.html.erb) to include webpack in the asset pipeline
* Create a basic home_controller.rb to have something to show when the app launch
* Create a basic HomeIndex.jsx to have something to show when the app launch
* [react-rails][] gem for React integrity on Rails.
* [reactstrap][] npm for base React components.
* [bullet][] gem to track N+1 queries. (with config)
* [fast_jsonapi][] gem for json serializer. (with config & example)
* [json-api-normalizer][] npm for json normaliazer. (with example)
* [rails_erd][] gem to generate automatically a schema of our database relationships. (with config)
* [better-errors][] and [xray-rails][] gem for easier debugging
* [awesome-print][] and [table-print][] for easier exploration in the terminal

#### Optional configuration

* [devise][] can be added and configured directly using react
* 

## React generator

I have added react specific generator task.

with `rails g react:pages home/index

It generates

* `app/react/pages/home/Index.js` with simple rendered props as json.
* add react related codes to `app/controllers/home_controller.rb`'s index action. (created controller and action if they don't exist)

[mattbricson]: https://github.com/mattbrictson/rails-template
[damienlethiec]: https://github.com/damienlethiec/modern-rails-template
[react-rails]: https://github.com/reactjs/react-rails
[reactstrap]: https://github.com/reactstrap/reactstrap
[bullet]: https://github.com/flyerhzm/bullet
[fast_jsonapi]: https://github.com/Netflix/fast_jsonapi
[json-api-normalizer]: https://github.com/yury-dymov/json-api-normalizer
[rails_erd]: https://github.com/voormedia/rails-erd
[better-errors]: https://github.com/charliesome/better_errors
[xray-rails]: https://github.com/brentd/xray-rails
[awesome-print]: https://github.com/michaeldv/awesome_print
[table-print]: https://github.com/arches/table_print
