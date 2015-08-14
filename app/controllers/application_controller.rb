#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :store_location
  

  def store_location
    # store last url
    return unless request.get?
    if (request.path != new_user_session_path &&
        request.path != new_user_registration_path &&
        request.path != new_user_password_path &&
        request.path != edit_user_password_path &&
        request.path != destroy_user_session_path &&
        !request.xhr?)
      session[:previous_url] = request.fullpath
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name
  end

  def after_sign_in_path_for(_resource)
    session[:previous_url] || root_path
  end
end
