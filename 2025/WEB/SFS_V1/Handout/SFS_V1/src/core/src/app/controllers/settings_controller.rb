class SettingsController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :require_user

  def settings
    @user = User.find(session[:user_id])
    @settings = @user.setting || Setting.new(user: @user)

    if request.get?
      render :settings

    elsif request.post?
      unless settings_params[:file].present? && settings_params[:json_data].present?
        flash[:error] = "Both file and JSON settings are required"
        return render :settings, status: :unprocessable_entity
      end

      begin
        user_settings = JSON.parse(settings_params[:json_data], max_nesting: 150)
        added_settings = Utils::Add.adder(@settings, user_settings)

        @settings.assign_attributes(
          isolated: added_settings[:isolated],
          random: added_settings[:random],
          extension: added_settings[:extension]
        )
      
        filename = File.basename(settings_params[:file].original_filename).gsub(/[^a-zA-Z0-9.\-_]/, "")
        if filename.blank?
          flash[:error] = "Invalid filename"
          return render :settings, status: :unprocessable_entity
        end

        if @settings.persisted? && @settings.file_path.present?
          flash[:error] = "You have already uploaded a file"
          return render :settings, status: :unprocessable_entity
        end

        if @settings.extension == false
          filename = File.basename(filename, ".*")
        end

        upload_path = Rails.root.join("uploads")
        if @settings.isolated
          upload_path = upload_path.join("isolated")
        elsif @settings.random
          upload_path = upload_path.join("random")
        end

        FileUtils.mkdir_p(upload_path)
        final_path = upload_path.join(filename)

        unless final_path.to_s.start_with?(Rails.root.join("uploads").to_s)
          flash[:error] = "Invalid file path"
          return render :settings, status: :unprocessable_entity
        end

        File.open(final_path, "wb") do |file|
          file.write(settings_params[:file].read)
        end

        @settings.file_path = final_path.relative_path_from(Rails.root).to_s

        if @settings.save
          flash[:notice] = "Settings updated and file uploaded successfully!"
        else
          flash[:error] = @settings.errors.full_messages.join(", ")
        end
      rescue JSON::ParserError
        flash[:error] = "Invalid JSON format"
      end

      render :settings, status: flash[:error] ? :unprocessable_entity : :ok
    end
  end

  private

  def require_user
    unless session[:user_id]
      flash[:error] = "Please register first"
      redirect_to register_path
    end
  end

  def settings_params
    params.permit(:json_data, :file, :commit, :authenticity_token)
  end
end