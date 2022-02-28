#!/usr/bin/env ruby

require 'win32/registry'

# Steam registry key name.
STEAM_KEYNAME = 'SOFTWARE\\Valve\\Steam'

# Access rights.
ACCESS = Win32::Registry::KEY_READ

def get_game_id
  begin
    Win32::Registry::HKEY_CURRENT_USER.open(STEAM_KEYNAME, ACCESS)['RunningAppID'] or
      raise 'No RunningAppID could be found from the registry! :/'
  rescue Win32::Registry::Error => e
    raise "Registry error: maybe steam isn\'t running? #{e.message}"
  end
end

def init_gabber
  # For now just print the game ID.
  puts get_game_id
end
