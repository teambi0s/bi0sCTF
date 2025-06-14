class ValidateController < ApplicationController
  before_action :require_user

  def index
    @user = User.find(session[:user_id])

    begin
      parsed_url = URI.parse(@user.url)
      if parsed_url.scheme != "http" && parsed_url.scheme != "https"
        flash.now[:error] = "Only http, https schemes allowed"
      elsif parsed_url.host && parsed_url.host != "localhost"
        flash.now[:error] = "Validation failed: validation is only possible if you're part of the local network"
      else
        require Rails.root.join('app/controllers/healthcheck_controller')
        if HealthcheckController.new.validate_path(@user.url, @user)
          @user.update!(validated: true)
          flash.now[:notice] = "URL validated successfully! Your account is now validated."
        else
          flash.now[:error] = "Validation failed: You must only give your personal URL"
        end
      end
    rescue URI::InvalidURIError
      flash.now[:error] = "Invalid URL format."
    end
  end

  private

  def require_user
    unless session[:user_id]
      flash[:error] = "Please register first"
      redirect_to register_path
    end
  end
end