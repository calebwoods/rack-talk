require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

run lambda { |env| [200, {}, ['Hello World!']] }
