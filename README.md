[![CI](https://github.com/Deradon/that_language-service/actions/workflows/ci.yml/badge.svg)](https://github.com/Deradon/that_language-service/actions/workflows/ci.yml)

# ThatLanguage::Service

A thin [Sinatra](https://sinatrarb.com) wrapper that exposes the
[ThatLanguage](https://github.com/Deradon/that_language) language-detection
library over HTTP as eight JSON endpoints.

This is a **library gem, not an application**: it ships a `config.ru` but
declares no web server, so the deployment picks its own.

## Installation

Add it to your Gemfile:

```ruby
gem "that_language-service"
```

> **Note.** The published `that_language` 0.1.2 on rubygems.org predates the
> Ruby 3+ fixes and will not run on a modern Ruby. Until `that_language` 0.1.3
> is released, point at the source directly:
>
> ```ruby
> gem "that_language", git: "https://github.com/Deradon/that_language.git"
> ```

## Running it

```console
$ bundle install
$ bundle exec puma config.ru -p 9292
```

Then:

```console
$ curl --get --data-urlencode 'text=Hallo Welt' http://localhost:9292/detect
{"language":"German","language_code":"de","confidence":0.5}
```

## Endpoints

Every endpoint answers both `GET` and `POST`, takes the input in a `text`
parameter, and responds with `Content-Type: application/json`.

| Endpoint | Returns |
|---|---|
| `/language` | `{"language": "German"}` |
| `/language_code` | `{"language_code": "de"}` |
| `/detect` | `{"language": …, "language_code": …, "confidence": …}` |
| `/details` | the full ranked result set, best match first |
| `/available` | `{"available": {"de": "German", …}}` |
| `/available_languages` | list of language names |
| `/available_language_codes` | list of language codes |
| `/version` | the **core library** version, not the service version |

`/details` returns every candidate language with its scoring breakdown:

```json
{"results":[{"language":"German","language_code":"de","confidence":0.5,
             "value":1.0,"hit_ratio":0.5,"hit_count":1,"words_count":2}]}
```

## Configuration

The wordlist tier is a property of the core library, not of this service.
Configure it before the application is mounted:

```ruby
ThatLanguage.configure do |config|
  config.wordlist_path = File.join("wordlists", "100k")
end
```

**Warm the cache at boot.** The wordlists are loaded lazily on the first
request, which costs about a second and a few hundred megabytes. Without a
warm-up the first user pays for it:

```ruby
ThatLanguage.language_code("Hello world!")  # in config.ru, before `run`
```

### Cross-origin requests

`Rack::Protection::JsonCsrf` is deliberately disabled — it answers `403` to any
request carrying a cross-origin `Referer`, which would block the intended
browser use case while guarding data that is already public. CORS headers are
not set here; the deployment adds them.

## Development

```console
$ bundle install
$ bundle exec rspec
$ bundle exec rubocop
```

Requires Ruby >= 3.1; developed and pinned against 4.0.6
(see `.tool-versions`).

## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/Deradon/that_language-service>. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](https://contributor-covenant.org) code of
conduct.

## License

Available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
