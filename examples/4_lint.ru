use Rack::Lint
run lambda { |env| [204, {'Content-Length' => '12'}, ['Hello World!']] }
