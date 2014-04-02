require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body(nested)
  # 3. route params
  def initialize(req, route_params = {})

    decoded = URI.decode_www_form(req.query_string)

    @params = {}

    #URI::decode_www_form("hi[hey]=5", enc=Encoding::UTF_8)
  end

  def [](key)
  end

  def permit(*keys)
  end

  def require(key)
  end

  def permitted?(key)
  end

  def to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)


  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
  end
end
