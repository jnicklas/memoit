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

## Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434).

## License

[MIT](License.txt)
