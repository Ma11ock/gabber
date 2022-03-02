#!/usr/bin/env ruby

# Gabber is a Ruby module that gets the name of the currently running
# steam game. Does not any API keys, no web scraping either!

require 'uri'
require 'net/http'
require 'json'

$game_id = 0

case RUBY_PLATFORM
when /linux/ # Linux.
  require 'vdf'
  begin
    parsed = File.open(File.join(Dir.home, '.steam', 'registry.vdf'), 'r') do |file|
      VDF.parse(file)
    end
    ($game_id = parsed['Registry']['HKCU']['Software']['Valve']['Steam']['RunningAppID']) or
      raise 'Could find the running app ID from the steam VDF file ! :/'
  rescue
    raise 'Running app ID could not be found ! :/'
  end
when /bsd/
  raise 'BSD is not yet supported ! :/' # BSD.
when /cygwin|mswin|mingw|bccwin|wince|emx/ # Windows.
  require 'win32/registry'

  # Steam registry key name.
  STEAM_KEYNAME = 'SOFTWARE\\Valve\\Steam'

  # Access rights.
  ACCESS = Win32::Registry::KEY_READ

  begin
    ($game_id = Win32::Registry::HKEY_CURRENT_USER.open(STEAM_KEYNAME, ACCESS)['RunningAppID']) or
      raise 'No RunningAppID could be found from the registry! :/'
  rescue Win32::Registry::Error => e
    raise "Registry error: maybe steam isn\'t running? #{e.message}"
  end
when /darwin|mac/ # MacOS.
  raise 'Mac is not yet supported ! :/'
else
  raise 'Your operating system not supported ! :/'
end


steam_api_call = URI("https://store.steampowered.com/api/appdetails/?appids=#{$game_id}")
res = Net::HTTP.get_response(steam_api_call)

obj = JSON.parse(res.body)
puts (obj["#{$game_id}"]['data']['name'] or 
      raise 'Could not get the required field from Steam API response ! :/')
