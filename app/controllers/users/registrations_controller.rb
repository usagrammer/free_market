# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  layout 'no_menu'

  def select  ##登録方法の選択ページ
    @auth_text = "で登録する"
    session.delete(:"devise.sns_auth") if session["devise.sns_auth"]
  end

  # GET /resource/sign_up
  def new
    ## ↓sessionにsns認証のデータがある場合
    @user = User.new(session["devise.sns_auth"]["user"]) if session["devise.sns_auth"]
    ## ↓sessionにsns認証のデータがない場合
    super if !session["devise.sns_auth"]
  end

  # POST /resource
  def create
    redirect_to new_user_registration_path, alert: "reCAPTCHAを承認してください" and return unless verify_recaptcha
    super if !session["devise.sns_auth"]
    if session["devise.sns_auth"]
      pass = Devise.friendly_token
      params[:user][:password] = pass
      params[:user][:password_confirmation] = pass
      sns = SnsCredential.new(session["devise.sns_auth"]["sns"])
      super
      if user_signed_in?
        sns.user_id = current_user.id
        sns.save
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
