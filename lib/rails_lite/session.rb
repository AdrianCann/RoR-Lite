require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)

    my_val = nil
    req.cookies.each do |cookie|
      my_val = cookie.value if cookie.name == '_rails_lite_app'
    end

    if my_val
      @hash = JSON.parse(my_val)
    else
      @hash = {}
    end

    #my_cookie = WEBrick::Cookie.new([my_val])
    #WEBrick::HTTPResponse.cookies << my_cookie
  end

  def [](key)
    @hash[key]

  end

  def []=(key, val)
    @hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)

    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @hash.to_json)
  end
end
