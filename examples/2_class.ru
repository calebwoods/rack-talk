require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

class App

  def call(env)
    [200, {}, ['Hello World!']]
  end

end

run App.new
