use Rack::Deflater
run lambda { |env|
  content = File.read(File.expand_path('../lots_o_content.txt', __FILE__))
  [200, {}, [content]]
}
