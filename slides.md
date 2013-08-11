# Rack

## Abstract

Rack is is the powerful tool that our favorite ruby web frameworks are built on, but how much do you know about how it works? In the first part of the talk we'll look at the anatomy Rack and how it's simple composeable interface can be leverage to make our Ruby web apps better.  In doing so we'll see how simple it is to get a Rack application up and running.

We'll then look at a number of real world examples of how Rack and Rack Middleware can be used to elegantly solve problems, speed up your applications, improve your development environment, and clean up your application code.

Caleb Woods especially enjoys solving business problems with technology in a lean approach.  At RoleModel Software he works with clients solving problems with Ruby and Service Oriented Architecture.  Caleb is also passionate about mentorship and is always looking for ways to teach and learn from other developers.

!SLIDE

# Rack

!SLIDE left

## What is Rack

* Project website: Rack provides a minimal interface between webservers supporting Ruby and Ruby frameworks.

!NOTES

http://rack.github.io/
Rack::Lint
http://yeahnah.org/files/rack-presentation-oct-07.pdf

!SLIDE left

## [Rack Spec](http://rack.rubyforge.org/doc/SPEC.html)

* Ruby class that responds to `call`
* Take 1 argument the `environment`
* Returns an Array with 3 values: status, headers, and body

!SLIDE left

## Simplest Example

```ruby
# examples/1_simple.ru

run lambda { |env| [200, {}, ['Hello World!']] }
```

* Lambda responds to call
* `body` is an Array because it needs to respond to each

!SLIDE left

## Class Example

```ruby
# examples/2_class.ru

class App

  def call(env)
    [200, {}, ['Hello World!']]
  end

end

run App.new
```

!SLIDE left

## Middleware

* Allows you compose a stack of Rack applications
* [Rack::Build](http://rack.rubyforge.org/doc/Rack/Builder.html) gives us a small DSL to construct our apps

```ruby
# examples/3_middleware.ru

class ContentLegthMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    # do work
  end
end

use ContentLegthMiddleware
run lambda { |env| [200, {}, ['Hello World!']] }
```
!SLIDE left

## [Rack::Lint](http://rack.rubyforge.org/doc/Rack/Lint.html)

* Validates your application/middleware against the [Rack Spec](http://rack.rubyforge.org/doc/SPEC.html)
* When used will show an error page if app violates spec

```ruby
# example/4_lint.ru

use Rack::Lint
run lambda { |env| [204, {'Content-Length' => '12'}, ['Hello World!']] }
```

!SLIDE left

## [Rack::URLMap](http://rack.rubyforge.org/doc/Rack/URLMap.html)

* Allows you construct a hash mapping of urls to Rack apps
* Works by changing the SCRIPT_NAME and PATH_INFO variables when dispatching

```ruby
# examples/5_map.ru

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
```

!SLIDE left

## Rails Router

The [Rails Router](https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/routing/mapper.rb) uses the same principle, every action is Rack app

```ruby
# This standard route
get "/", to: "posts#index"

# maps to
get "/", to: PostsController.action(:index)
```

```ruby
mount SintraApp, at: "/sinatra"
```

!SLIDE left

## Rails Router

### Match vs Mount

* Match (get, post, ..) - matches on full path
* Mount (SintraApp) - matches on the path prefix

```ruby
# REQUEST: GET /sinatra/sub_route

get "/sinatra/specific", to: "posts#index"

mount SintraApp, at: "/sinatra"

# other uses
mount Sidekiq, at: "/sidekiq"
mount Grape::API, at: "/api"
```

!SLIDE left

## Rack in the Wild

* How can we leverage Rack in the Rails apps we are building
* Examples from Rails and personal usage

!SLIDE left

## rake middleware

```ruby
# rails 4 app with Devise
use ActionDispatch::Static
use Rack::Lock
use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007ff9c2f32d48>
use Rack::Runtime
use Rack::MethodOverride
use ActionDispatch::RequestId
use Rails::Rack::Logger
use ActionDispatch::ShowExceptions
use ActionDispatch::DebugExceptions
use ActionDispatch::RemoteIp
use ActionDispatch::Reloader
use ActionDispatch::Callbacks
use ActiveRecord::Migration::CheckPending
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use ActiveRecord::QueryCache
use ActionDispatch::Cookies
use ActionDispatch::Session::CookieStore
use ActionDispatch::Flash
use ActionDispatch::ParamsParser
use Rack::Head
use Rack::ConditionalGet
use Rack::ETag
use Warden::Manager
run Sample::Application.routes
```

!SLIDE left

## Rack Cache

* The middleware you don't know you use

!SLIDE left

## Idempotent Post

* Define idempotent
* Mobile sometimes connected app
* Payment Form
  * Rails CRFM

!SLIDE left

## App Status

* [Pinglish](https://github.com/jbarnette/pinglish)
* More about app status than 200 OK

!SLIDE left

## Turbo Dev

* Only server assets if they've changed while in dev
* Source: https://github.com/discourse/discourse/blob/master/lib/middleware/turbo_dev.rb

## Compression

* Gzip compression

!SLIDE left

## Cucumber Test Login Backdoor

* Show devise sample code devise
* Source: http://robots.thoughtbot.com/post/37907699673/faster-tests-sign-in-through-the-back-door

!SLIDE left

## External Request when Testing

* SpreedlyCore middleware
* Allows the use of VCR

!SLIDE left

## Gems that leverage Middleware

* [Better Errors](https://github.com/charliesome/better_errors)

!SLIDE left

## Other ideas

* [Email Exceptions](https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/mailexceptions.rb)
* [Directory Viewer](https://github.com/rack/rack/blob/master/lib/rack/directory.rb)
* [Rack Embed](https://github.com/minad/rack-embed)
* [Chrome Logger](https://github.com/cookrn/chrome_logger)

!SLIDE

# Further Reading/Watching

* Jose Valim - [You've a got a Sinatra on your Rails [RailsConf 2013]](http://www.confreaks.com/videos/2442-railsconf2013-you-ve-got-a-sinatra-on-your-rails)
  * Great look how Rails uses Rack internally
* RailsCast - [Rack App from Scratch](http://railscasts.com/episodes/317-rack-app-from-scratch)
* Jason Seifer - [32 Rack Resources to get you Started](http://jasonseifer.com/2009/04/08/32-rack-resources-to-get-you-started)
* [List of Rack Middleware](https://github.com/rack/rack/wiki/List-of-Middleware)
