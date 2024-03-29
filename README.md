# Memoit

[![Gem Version](https://badge.fury.io/rb/memoit.svg)](http://badge.fury.io/rb/memoit)
[![Build Status](https://github.com/jnicklas/memoit/actions/workflows/ci.yml/badge.svg)](https://github.com/jnicklas/memoit/actions/workflows/ci.yml)

Memoizes methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'memoit'
```

## Usage

``` ruby
class Foo
  memoize def bar(value)
    expensive_calculation(value)
  end

  memoize_class_method def self.baz(value)
    expensive_calculation(value)
  end
end
```

## Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434).

## Development

```sh
gem install bundler
bundle install
rspec
```

## License

[MIT](LICENSE.txt)
