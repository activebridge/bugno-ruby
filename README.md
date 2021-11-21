# Bugno

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bugno'
```

And then execute:

    $ bundle

## Usage

    $ rails g bugno [API-KEY]

## Configuration

To setup additional configuration navigate to `config/initializers/bugno.rb` in your app directory

#### Send in background with threading:
Send exceptions asynchronous

    config.send_in_background = true

#### Send rails exceptions
Change following line to skip rails exceptions:

    config.exclude_rails_exceptions = false

#### Specify rails exceptions to suppress
Suppress only exceptions you wish to (e.g. ActionController::RoutingError), make sure `config.exclude_rails_exceptions = true` specified:

    config.excluded_exceptions = ['ActionController::RoutingError']

#### Specify or add usage environments:
    config.usage_environments = %w[production]
    config.usage_environments << 'development'

#### Specify current user method:
Allows you to send user related data

    config.current_user_method = 'current_user'

Leave it blank to prevent
#### Add scrub fields and headers:
Filters sensetive params(e.g. passwords, tokens, credit cards)

    config.scrub_fields << 'password'
    config.scrub_headers << 'access_token'

##### Defaults fields:
    passwd password password_confirmation secret confirm_password password_confirmation secret_token api_key access_token session_id

##### Defaults header:
    Authorization

#### Use bugno handler in rescue case:
     def index
        no_method_error
        rescue StandardError => e
        Bugno::Handler.call(exception: e)
     end
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
