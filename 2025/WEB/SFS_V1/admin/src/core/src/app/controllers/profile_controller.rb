class ProfileController < ApplicationController
  def show
    # Timeout to prevent overloading the server
    start_time = Time.now
    while Time.now - start_time < 5 
    end
    user = User.find_by(username: params[:username])
    if user
      render json: {
        username: user.username,
        url: user.url,
        validated: user.validated
      }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end