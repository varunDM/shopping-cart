#
# Actions for all the controllers
#
# @author [qbuser]
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :store_location

  # store last url
  #
  def store_location
    return unless request.get?
    if request.path != new_user_session_path &&
       request.path != new_user_registration_path &&
       request.path != destroy_user_session_path &&
       !request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  # Store activity log to db
  #
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

  # Redirect to previous url after sign in
  #
  def after_sign_in_path_for(_resource)
    activity_log('logged into the system')
    session[:previous_url] || root_path
  end

  # Redirect to home page after sign in
  #
  def after_sign_out_path_for(_resource)
    root_path
  end
end
