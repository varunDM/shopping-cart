#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(_resource)
    if current_user.role == 1
      admin_index_path
    elsif current_user.role == 2
      company_index_path
    elsif current_user.role == CUSTOMER
      company_index_path
    end
  end
end
