# Ruby Recorder

Recorder dumps the result of your ruby code to a YAML file for faster tests or to compare the result between two execution.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-recorder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-recorder

## Exemples

### Refactor

Imagine you want to refactor an endpoint on your backend api and want to make sure the response is the same:

```
  Recorder.config do |c|
    c.verbose = true
    c.stubb = false
  end

  # this will call your backend and 
  # dump the result in refactor.yml
  # let's say the response is : [{"username"=>"Michael Bensoussan"}]
  Recorder.dump_to('refactor.yml') do
    HTTParty.get('http://my_backend/users').parsed_response
  end

  # this will call your backend and compare the result to
  # what's in refactor.yml ([{"username"=>"Michael Bensoussan"}])
  # let's say the new response is [{"username"=>"Michael"}]
  Recorder.dump_to('refactor.yml') do
    HTTParty.get('http://my_backend/users').parsed_response
  end

```

Executing this code will outputs a (colored) diff :

```
  Recorder: result is different from last run
  ---
  - username: Michael Bensoussan- username: Michael
```

### Faster tests

The first time you run this test, you will call the backend but for all the following runs `Recorder` will load the result from the YAML file.

```
  class TestRecorder < MiniTest::Unit::TestCase

    def setup
      Recorder.config do |c|
        c.verbose = true
        c.stubb = true
        c.records_dir = 'backend_responses/'
      end
    end

    def test_users
      users = Recorder.dump_to('refactor.yml') do
        HTTParty.get('http://my_backend/users').parsed_response
      end

      assert_equal [{"username"=>"Michael Bensoussan"}], users
    end

  end
```

## Usage

```
  Recorder.config do |c|
    c.verbose = true
    c.records_dir = 'records/'
    c.stubb = false
  end
```

### records_dir

The `records_dir` option sets the directory where your records will be saved.

### stubb

When `stubb = true`, your code will only be run once. Future runs will load the result from the yaml file.
When `stubb = false`, your code will be run every time.

### verbose

The `verbose` option will outputs a nice diff (with the `differ` gem) if the output is different from the last run.
Of course this only works if `stubb = false`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
