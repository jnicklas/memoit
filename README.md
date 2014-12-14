# Memoit

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
end
```

## License

[MIT](License.txt)
