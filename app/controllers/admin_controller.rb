#
class AdminController < ApplicationController
  def index
    @user = User.new
    @companies = User.where(role: 2)
    @categories = Category.all
  end
end
