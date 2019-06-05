# Bughub

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bughub', github: 'activebridge/bughub-ruby'
```

And then execute:

    $ bundle

## Usage

    $ rails g bughub [API-KEY]

OR

    $ rails g bughub
    $ export BUGHUB-API_KEY=[API_KEY]

## Configuration

To setup additional configuration navigate to `config/initializers/bughub.rb` in your app directory

#### Send rails exceptions
By default BugHub does not send rails exceptions, if you want to change this behavior specify following line in config file:

    config.exclude_rails_exceptions = false
#### Specify rails exceptions suppressing
Also you can suppress only exceptions you wish to (e.g. ActionController::RoutingError), make you are not excluding all the exceptions with `exclude_rails_exceptions`( should be `true` ):

    config.excluded_exceptions = ['ActionController::RoutingError']

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
