class ApplicationController < ActionController::Base
    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    protect_from_forgery with: :null_session
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_in) do |user_params|
            user_params.permit(:email_or_username, :password)
        end

        devise_parameter_sanitizer.permit(:sign_up) do |user_params|
            user_params.permit(:email, :username, :display_name, :password, :password_confirmation)
        end

        devise_parameter_sanitizer.permit(:account_update) do |user_params|
            user_params.permit(:email, :username, :display_name, :password, :password_confirmation, :current_password)
        end
    end

    private

    def user_not_authorized
        render json: { 'errors': ['Unauthorized!']}, status: :unauthorized
    end
end
