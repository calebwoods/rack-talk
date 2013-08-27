require 'rack/cache'

use Rack::Cache
run lambda { |env|
  headers = { 'Cache-Control' => 'max-age=5, public' }
  [200, headers, ["Hello at: #{Time.now}"]]
}
