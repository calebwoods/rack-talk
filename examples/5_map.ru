map "/app_1" do
  run lambda { |env| [200, {}, ['Hello from app_1!']] }
end

map "/app_2" do
  map "/nested" do
    run lambda { |env| [200, {}, ["SCRIPT_NAME: #{env['SCRIPT_NAME']}\nPATH_INFO: #{env['PATH_INFO']}"]] }
  end
  run lambda { |env| [200, {}, ['Hello from app_2!']] }
end

run lambda { |env| [200, {}, ["PATH_INFO: #{env['PATH_INFO']}"]] }
