class RegisterController < ApplicationController
  
  skip_before_action :verify_authenticity_token

  def register
    if request.get?
      render :register
    elsif request.post?
      username = params[:username]
      url = params[:url]

      if url&.downcase&.include?("localhost")
        flash[:error] = "You are not part of the internal network"
        return render :register, status: :unprocessable_entity
      end

      if User.exists?(username: username)
        flash[:error] = "Can't register: Username already taken"
        render :register, status: :unprocessable_entity
      else
        user = User.new(username: username, url: url, validated: false)
        if user.save
          session[:user_id] = user.id
          flash[:notice] = "User registered successfully!"
          redirect_to register_path
        else
          flash[:error] = user.errors.full_messages.join(", ")
          render :register, status: :unprocessable_entity
        end
      end
    end
  end
end