require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

class ContentLengthMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers['Content-Length'] = body.inject(0) do |l, p|
      l + Rack::Utils.bytesize(p)
    end.to_s
    [status, headers, body]
  end

end

use ContentLengthMiddleware
run lambda { |env| [200, {}, ['Hello World!']] }
