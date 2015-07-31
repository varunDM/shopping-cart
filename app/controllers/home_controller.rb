#
class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.role == 1
        redirect_to admin_index_path
      elsif current_user.role == 2
        redirect_to company_index_path
      end
    end
  end
end
