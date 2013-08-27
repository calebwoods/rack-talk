use Rack::Deflater
run lambda { |env|
  content = <<-TEXT
    Need some longish content to compress.
    If content is too short compressing add overhead because of headers.
  TEXT
  [200, {}, [content]]
}
