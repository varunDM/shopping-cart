#
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user
  def index
    @user = User.new
    @companies = User.where(role: COMPANY)
    @categories = Category.all
  end

  def check_user
    redirect_to home_index_path unless current_user.role == SUPERADMIN
  end
end
