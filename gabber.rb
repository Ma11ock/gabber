#!/usr/bin/env ruby

# Gabber is a 


case RUBY_PLATFORM
when /cygwin|mswin|mingw|bccwin|wince|emx/
  require './gabber_win32'
when /linux/
  require './gabber_linux'
when /bsd/
# TODO
when /darwin|mac/
# TODO
else
  raise 'Operating system not supported ! :/'
end

