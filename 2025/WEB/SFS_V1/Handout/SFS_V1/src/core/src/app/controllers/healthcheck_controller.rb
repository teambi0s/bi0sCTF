require 'net/http'

class HealthcheckController < ApplicationController
  @@admin_username = "admin"
  @@admin_url = "http://localhost:3000"
  def self.admin_username
    @@admin_username
  end

  def self.admin_url
    @@admin_url
  end

  def index
    admin_exists = User.where("username = '#{HealthcheckController.admin_username}'")
    if admin_exists.size != 0 
      begin
        uri = URI.parse(HealthcheckController.admin_url)
        if uri.hostname == "localhost"
          response = Net::HTTP.get_response(uri)
          if response.is_a?(Net::HTTPSuccess) 
            puts "Everythings working and the system is up"
          else
            puts "!!!!System is still booting!!!!"
          end
        else
          puts "!!!!Corrupt url!!!!"
        end
      rescue StandardError => e
        puts e
      end
    else
      puts "!!!!Admin user not loaded, need to restart the service!!!!"
    end

    head :ok
  end

  def validate_path(url, current_user)
    return false unless current_user
  
    begin
      parsed_url = URI.parse(url)
      path_segments = parsed_url.path&.split('/')&.reject(&:empty?)
      last_segment = path_segments&.last
      last_segment == current_user.username
    rescue URI::InvalidURIError
      false
    end
  end 
end

