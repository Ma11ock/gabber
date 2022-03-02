#!/usr/bin/env ruby

require 'vdf'


begin
  parsed = File.open(File.join(Dir.home, '.steam', 'registry.vdf'), 'r') do |file|
    VDF.parse(file)
  end
  appID = parsed['Registry']['HKCU']['Software']['Valve']['Steam']['RunningAppID']
  puts appID
rescue
  raise 'Running app ID could not be found ! :/'
end
