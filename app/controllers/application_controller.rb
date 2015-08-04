#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name
  end

  def after_sign_in_path_for(_resource)
    if current_user.role == SUPERADMIN
      admin_index_path
    elsif current_user.role == COMPANY
      company_index_path
    elsif current_user.role == CUSTOMER
      customer_index_path
    end
  end

end
