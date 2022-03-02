#!/usr/bin/env ruby

# Gabber is a Ruby module that gets the name of the currently running
# steam game. Does not any API keys, no web scraping either!

require 'uri'
require 'net/http'
require 'json'

case RUBY_PLATFORM
when /cygwin|mswin|mingw|bccwin|wince|emx/
  require './gabber_win32'
when /linux/
  require './gabber_linux'
when /bsd/
  raise 'BSD is not yet supported ! :/'
when /darwin|mac/
  raise 'Mac is not yet supported ! :/'
else
  raise 'Your operating system not supported ! :/'
end


steam_api_call = URI("https://store.steampowered.com/api/appdetails/?appids=431240")
res = Net::HTTP.get_response(steam_api_call)

obj = JSON.parse(res.body)
puts obj['431240']['data']['name']
