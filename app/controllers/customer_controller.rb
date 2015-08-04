#
class CustomerController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user
  def index
  end

  def check_user
    redirect_to home_index_path unless current_user.role == CUSTOMER
  end
end
