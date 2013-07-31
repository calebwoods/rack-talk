# Rack

## Abstract

Rack is is the powerful tool that our favorite ruby web frameworks are built on, but how much do you understand how it works. In first part of the talk we'll look at the anatomy of basic Rack app and middleware to see how we can.

We will then examine example of how rack can used to solve elegantly and clean up your application code.

!SLIDE

# Rack

!SLIDE left

## What is Rack

* Definition of Protocol
* Rack::Lint

!SLIDE left

## How Simple Can Rack App Be?

* Lambda responds to call
* Show code
* Show on heroku

!SLIDE left

## Middleware

* Stack of Rack Applications
* Call chain
* Demonstrate call chain with sample code

!SLIDE left

## Rack Routing with Mapping

* Looking to and provide example
* Use to build simple sinatra
* https://medium.com/ruby-on-rails/71f94858320

!SLIDE left

## Mounting an app inside an App - Meta

* Sidekiq
* Grape

!SLIDE left

## How can we use this in the wild

* Examples from usage at RoleModel
* You use a lot of middleware already
  * rake middleware

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
