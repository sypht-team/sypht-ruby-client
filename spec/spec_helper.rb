require "sypht/client"
require "coveralls"

Coveralls.wear!

require 'pry'

def validate_uuid_format(uuid)
  uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
  uuid_regex.match?(uuid.to_s.downcase)
end

def upload_invoice(filesets)
  @client.upload("samples/sample_invoice.pdf", filesets)
end

def check_keys(keys, result)
  keys.each do  |k|
    expect(result.key? k)
  end
end