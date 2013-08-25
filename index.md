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

!SLIDE

}}} images/field.jpg::http://www.flickr.com/photos/arturstaszewski/7048604301

# Rack in the "field"

!SLIDE diagram

## Normal API POST Request

![API Normal](images/api_normal.png)

!NOTES

http://www.websequencediagrams.com/cgi-bin/cdraw?lz=aVBhZC0-UmFpbHM6IFBPU1QgUmVxdWVzdApub3RlIHJpZ2h0IG9mIAAbBwAkBSBjcmVhdGVzIG9iamVjdAoAOQUtPmlQYWQ6IFJlc3BvbnNlCg&s=napkin

!SLIDE diagram

## iPad Drops Connection

![API Dropped](images/api_default.png)

!NOTES

http://www.websequencediagrams.com/cgi-bin/cdraw?lz=aVBhZC0-UmFpbHM6IFBPU1QgUmVxdWVzdApub3RlIHJpZ2h0IG9mIAAbBwAkBSBjcmVhdGVzIG9iamVjdCBpZDogMQoAPwUtLT4-aVBhZDogUmVzcG9uc2UgMjAwIC0gaVBhZCBsb3N0IGNvbm5lY3Rpb24KAHANUmV0cnkARzwyAHwHAG4TCg&s=napkin

!SLIDE diagram

## Desired Results

![API Dedup](images/api_desired.png)

!NOTES

http://www.websequencediagrams.com/cgi-bin/cdraw?lz=aVBhZC0-UmFpbHM6IFBPU1QgUmVxdWVzdApub3RlIHJpZ2h0IG9mIAAbBwAkBSBjcmVhdGVzIG9iamVjdCBpZDogMQoAPwUtLT4-aVBhZDogUmVzcG9uc2UgMjAwIC0gaVBhZCBsb3N0IGNvbm5lY3Rpb24KAHANUmV0cnkAWilzZWVzIGR1cGxpY2F0ZWQAdwcAbBA0MDkgLSBTYW1lIGJvZHkgYXMAgSYH&s=napkin

!SLIDE left

## How can we solve this?

* Ruby Module
* Client Defined UUID
* Rack Middleware

!SLIDE

```ruby
module Rack
  class IdempotentPost
    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) unless env['REQUEST_METHOD'] == 'POST'

      dup_check = DuplicationChecker.new env

      if dup_check.duplicate?
        headers, body = dup_check.response
        [409, headers, body]
      else
        status, headers, body = @app.call(env)
        dup_check.cache_response(status, headers, body)
        [status, headers, body]
      end

    end

    class DuplicationChecker
    ...
    end
  end
end
```

!SLIDE

```ruby
class DuplicationChecker
  attr_reader :token, :uri, :raw_post_data

  def initialize(env)
    @token = http_basic_username(env['HTTP_AUTHORIZATION'])
    @uri = env['PATH_INFO']
    @raw_post_data = env['rack.input'].read
  end

  def duplicate?
    cacheable_request && !!redis.get(hash_key)
  end

  def cache_response(status, headers, body)
    return unless cacheable_request && [200, 201].include? status
    CachedPostResponse.create(hash_key: hash_key,
                              duplication_key: duplication_key,
                              response: [headers, body].to_json)
    redis.setex(hash_key, CachedPostResponse::KEY_TTL, true)
  end

  def response
    cached = CachedPostResponse.where(hash_key: hash_key, duplication_key: duplication_key).first
    JSON.parse(cached.response)
  end

  def hash_key; duplication_key.hash.to_s; end

  def duplication_key
    @duplication_key ||= "#{token}|#{uri}|#{raw_post_data}"
  end

  def cacheable_request; !raw_post_data.empty? && uri; end
end
```

!SLIDE left

## Idempotent Post Middleware

* Make no changes to your app
* Client just needs handle 409 response
* Can be useful in other part of app
  * Double submitting forms

!SLIDE left

## Other ways to use Middleware

* Caching
* Speed up Development & Test Environment
* App Monitoring
* Compression

!SLIDE left

## Rack Cache

* The middleware you don't know you use
* [Rack Cache Blog Post by Ryan Tomayko](http://tomayko.com/writings/things-caches-do)

!SLIDE left

## App Status

* [Pinglish](https://github.com/jbarnette/pinglish)
* https://github.com/TheClimateCorporation/unicorn-metrics
* More about app status than 200 OK

!SLIDE left

## Turbo Dev

* Only server assets if they've changed while in dev
* Source: https://github.com/discourse/discourse/blob/master/lib/middleware/turbo_dev.rb

!SLIDE left

## Cucumber Test Login Backdoor

* Show devise sample code devise
* Source: http://robots.thoughtbot.com/post/37907699673/faster-tests-sign-in-through-the-back-door

!SLIDE left

## External Request when Testing

* SpreedlyCore middleware
* Allows the use of VCR

!SLIDE left

## Compression

* Gzip compression - [Rack::Deflater](https://github.com/rack/rack/blob/master/lib/rack/deflater.rb)
  * [Slide Deck](http://calebwoods.github.io/http-compression-rails)
  * [Testing Gist](https://gist.github.com/calebwoods/5615260)
* Inline images - [Rack Embed](https://github.com/minad/rack-embed)

!SLIDE left

## Gems that leverage Middleware

* [Better Errors](https://github.com/charliesome/better_errors)

!SLIDE left

## Other ideas

* [Email Exceptions](https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/mailexceptions.rb)
* [Directory Viewer](https://github.com/rack/rack/blob/master/lib/rack/directory.rb)
* [Chrome Logger](https://github.com/cookrn/chrome_logger)

!SLIDE

# Questions

!SLIDE left

# Resources

* Jose Valim - [You've a got a Sinatra on your Rails [RailsConf 2013]](http://www.confreaks.com/videos/2442-railsconf2013-you-ve-got-a-sinatra-on-your-rails)
  * Great look how Rails uses Rack internally
* RailsCast - [Rack App from Scratch](http://railscasts.com/episodes/317-rack-app-from-scratch)
* Jason Seifer - [32 Rack Resources to get you Started](http://jasonseifer.com/2009/04/08/32-rack-resources-to-get-you-started)
* [List of Rack Middleware](https://github.com/rack/rack/wiki/List-of-Middleware)

!SLIDE left

# Feedback

* Github repo:
* Email: [caleb.woods@rolemodelsoftware.com](mailto:caleb.woods@rolemodelsoftware.com)
* Traingle.rb Mailing List
