require 'uri'
require 'net/http'
require 'json'

module Gabber
  class SteamGame
    attr_reader :current_game_id, :current_game_name, :hours_played

    def initialize
      @current_game_id = self.class.get_game_id
      @current_game_name = self.class.get_name_from_game_id @current_game_id
      @hours_played = 0
    end

    def self.get_game_id
      case RUBY_PLATFORM
      when /linux/ # Linux.
        require 'vdf'
        begin
          parsed = File.open(File.join(Dir.home, '.steam', 'registry.vdf'), 'r') do |file|
            VDF.parse(file)
          end
          (parsed['Registry']['HKCU']['Software']['Valve']['Steam']['RunningAppID']) or
            raise 'Could find the running app ID from the steam VDF file ! :/'
        rescue
          raise 'Running app ID could not be found ! :/'
        end
      when /bsd/
        raise 'BSD is not yet supported ! :/' # BSD.
      when /cygwin|mswin|mingw|bccwin|wince|emx/ # Windows.
        require 'win32/registry'
        # Steam registry key name.
        steam_keyname = 'SOFTWARE\\Valve\\Steam'

        # Access rights.
        access = Win32::Registry::KEY_READ
        begin
          (Win32::Registry::HKEY_CURRENT_USER.open(steam_keyname, access)['RunningAppID']) or
            raise 'No RunningAppID could be found from the registry! :/'
        rescue Win32::Registry::Error => e
          raise "Registry error: maybe steam isn\'t running? #{e.message}"
        end
      when /darwin|mac/ # MacOS.
        raise 'Mac is not yet supported ! :/'
      else
        raise 'Your operating system not supported ! :/'
      end
    end

    def self.get_name_from_game_id(game_id = self.get_game_id)
      return nil if game_id == 0

      steam_api_call = URI("https://store.steampowered.com/api/appdetails/?appids=#{game_id}")
      res = Net::HTTP.get_response(steam_api_call)

      obj = JSON.parse(res.body)
      return (obj["#{game_id}"]['data']['name'] or 
              raise 'Could not get the required field from Steam API response ! :/')
    end
  end
end

