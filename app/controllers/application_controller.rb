class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :configure_permitted_paramaters, if: :devise_controller? ## 追加

  private

  ## 追加
  def configure_permitted_paramaters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :avatar, :introduction, :first_name, :first_name_reading, :last_name, :last_name_reading, :birthday, :earnings, :points])
  end

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.basic[:auth_user] && password == Rails.application.credentials.basic[:auth_password]
    end
  end

end
