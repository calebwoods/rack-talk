class DeviseBackDoor
  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    sign_in_through_the_back_door
    @app.call(@env)
  end

  private

  def sign_in_through_the_back_door
    if user_id = params['as']
      user = User.find(user_id)
      scope = @env['warden'].config[:default_strategies].keys.first
      @env['warden'].session_serializer.store(user, scope)
    end
  end

  def params
    Rack::Utils.parse_query(@env['QUERY_STRING'])
  end
end

# Sign in code extracted from Devises Built in TestHelpers
# https://github.com/plataformatec/devise/blob/master/lib/devise/test_helpers.rb

Sample::Application.configure do
  # your existing test.rb contents go here
  config.middleware.use DeviseBackDoor
end
