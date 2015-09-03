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
    if request.path != new_user_session_path &&
       request.path != new_user_registration_path &&
       request.path != destroy_user_session_path &&
       !request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  def activity_log(action)
    @activity = ActivityLog.new
    @activity.user_id = current_user.id
    @activity.action = action
    @activity.ip = IPAddr.new(request.remote_ip).to_i
    @activity.save
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name
  end

  def after_sign_in_path_for(_resource)
    activity_log('logged into the system')
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(_resource)
    # activity_log('logged out of the system')
    root_path
  end
end
