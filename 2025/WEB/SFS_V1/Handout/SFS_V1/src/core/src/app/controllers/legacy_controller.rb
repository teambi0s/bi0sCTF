require 'net/http'
require 'securerandom'

class LegacyController < ApplicationController
  before_action :require_user
  before_action :require_validated
  before_action :require_legacy_cookie
  before_action :require_file_path, only: :index, if: -> { request.post? }

  def index
    @user = current_user
    
    if request.post?
      file_path = @user.setting.file_path
      user_string = params[:string] || ''
      user_key = params[:key] || ''
      
      begin
        uri = URI('http://legacy:3001')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path.empty? ? '/' : uri.path)
        
        boundary = "RubyFormBoundary#{SecureRandom.hex(10)}"
        request.content_type = "multipart/form-data; boundary=#{boundary}"
        
        body = []
        body << "--#{boundary}\r\n"
        body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{File.basename(file_path)}\"\r\n"
        body << "Content-Type: application/octet-stream\r\n"
        body << "\r\n"
        body << File.read(file_path, mode: 'rb')
        body << "\r\n"
        
        body << "--#{boundary}\r\n"
        body << "Content-Disposition: form-data; name=\"string\"\r\n"
        body << "\r\n"
        body << user_string
        body << "\r\n"
        
        body << "--#{boundary}\r\n"
        body << "Content-Disposition: form-data; name=\"key\"\r\n"
        body << "\r\n"
        body << user_key
        body << "\r\n"
        
        body << "--#{boundary}--\r\n"
        
        request.body = body.join
        request.content_length = request.body.bytesize
        
        response = http.request(request)
        
        if response.is_a?(Net::HTTPSuccess)
          flash[:notice] = "File securely stored in legacy systems"
          redirect_to legacy_path
        else
          flash[:error] = "Failed to store file in legacy systems"
          redirect_to settings_path
        end
      rescue Errno::ENOENT
        flash[:error] = "File not found at specified path"
        redirect_to settings_path
      rescue StandardError => e
        flash[:error] = "Error sending file: #{e.message}"
        redirect_to settings_path
      end
    else
      render :index
    end
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_user
    unless session[:user_id]
      flash[:error] = "Please register first"
      redirect_to register_path
    end
  end

  def require_validated
    return unless session[:user_id]
    unless current_user&.validated
      flash[:error] = "Access denied: User not validated"
      redirect_to settings_path
    end
  end

  def require_legacy_cookie
    unless cookies[:Legacy] == "fake_secret"
      flash[:error] = "Access denied: Invalid or missing Legacy cookie"
      redirect_to settings_path
    end
  end

  def require_file_path
    unless current_user.setting&.file_path&.present?
      flash[:error] = "First upload a file"
      redirect_to settings_path
    end
  end
end