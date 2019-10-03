# Sypht Ruby Client
This repository is a Ruby reference client implementation for working with the Sypht API at https://api.sypht.com.

## About Sypht
[Sypht](https://sypht.com) is a SaaS [API]((https://docs.sypht.com/)) which extracts key fields from documents. For 
example, you can upload an image or pdf of a bill or invoice and extract the amount due, due date, invoice number 
and biller information. 

## Getting started
To get started you'll need API credentials, i.e. a `<client_id>` and `<client_secret>`, which can be obtained by registering
for an [account](https://www.sypht.com/signup/developer)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sypht'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sypht
        
## Usage

```ruby
require 'sypht'

# API_KEY is stored as env variable in the format client_id:client_secret
client_id, client_secret = ENV['SYPHT_API_KEY'].split(":")

# Create new Sypht Client
@client = Sypht::Client.new(client_id, client_secret)

# Submit a file for upload, along with a list of fieldsets
fid = @client.upload("samples/sample_invoice.pdf", ['sypht.invoice'])

# get results of the file based on fid
results = @client.fetch_results fid
```

or run it in the command line:

```
$ sypht extract --fieldset sypht.document --fieldset sypht.invoice path/to/your/document.pdf
```

## Development

You need to install Ruby (2.5+), which can be installed using [RVM](https://rvm.io/rvm/install)

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To build and test the gem locally, run `rake install`, which will package the gem to "pkg/sypht-<version>.gem", and install it in the current ruby. 
You can then run `irb` and use the gem as mentioned in the usage section.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sypht-team/sypht-ruby-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [Apache License](https://github.com/sypht-team/sypht-ruby-client/blob/master/LICENSE).

## Code of Conduct

Everyone interacting in the Sypht Ruby Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sypht-team/sypht-ruby-client/blob/master/CODE_OF_CONDUCT.md).
