require_relative '../../lib/idempotent_post'
require 'rack/test'

describe Rack::IdempotentPost do
  include Rack::Test::Methods

  def app
    Rack::IdempotentPost.new(inner_app)
  end

  def inner_app
    lambda do |env|
      @inner_app_called += 1
      if env['PATH_INFO'] == '/error'
        [404, {'Content-Type' => 'text/plain'}, ["Call Count #{@inner_app_called}"]]
      else
        [200, {'Content-Type' => 'text/plain'}, ["Call Count #{@inner_app_called}"]]
      end
    end
  end

  before { @inner_app_called = 0 }

  after do
    redis = Redis.new
    keys = redis.keys
    redis.del(keys) if keys != []
  end

  it "does nothing with non POST request" do
    get "/posts"
    first_repsonse = last_response.body
    get "/posts"
    last_response.body.should_not eq first_repsonse
    @inner_app_called.should eq 2
  end

  it "returns same response for same request" do
    post "/posts", { sample_data: 'sample_value' }
    first_repsonse = last_response.body
    post "/posts", { sample_data: 'sample_value' }
    last_response.body.should eq first_repsonse
    @inner_app_called.should eq 1
  end

  it "does not cache different request" do
    post "/posts", { sample_data: 'sample_value1' }
    first_repsonse = last_response.body
    post "/posts", { sample_data: 'sample_value2' }
    last_response.body.should_not eq first_repsonse
    @inner_app_called.should eq 2
  end

  it "returns different response for different http basic users" do
    post "/posts", { sample_data: 'sample_value' }, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64('user1:X')}"
    first_repsonse = last_response.body
    post "/posts", { sample_data: 'sample_value' }, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64('user2:X')}"
    last_response.body.should_not eq first_repsonse
    @inner_app_called.should eq 2
  end

  it "does not cache error responses" do
    post "/error", { sample_data: 'sample_value' }
    first_repsonse = last_response.body
    post "/error", { sample_data: 'sample_value' }
    last_response.body.should_not eq first_repsonse
    @inner_app_called.should eq 2
  end

  it "does not cache empty posts" do
    post "/posts"
    first_repsonse = last_response.body
    post "/posts"
    last_response.body.should_not eq first_repsonse
    @inner_app_called.should eq 2
  end

  it "does not cache sessions request" do
    post "/sessions", { sample_data: 'sample_value' }
    first_repsonse = last_response.body
    post "/sessions", { sample_data: 'sample_value' }
    last_response.body.should_not eq first_repsonse
    @inner_app_called.should eq 2
  end

  it "does not cache api authenticate" do
    post "/user/authenticate.json", { sample_data: 'sample_value' }
    first_repsonse = last_response.body
    post "/user/authenticate.json", { sample_data: 'sample_value' }
    last_response.body.should_not eq first_repsonse
    @inner_app_called.should eq 2
  end

end
