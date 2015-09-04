#
# Company related activities
#
# @author [qbuser]
#
class CompanyController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user, only: [:index]

  # Company dashboard
  #
  def index
    @company = current_user
    @products = @company.products
  end

  # For creating a new company from admin view
  #
  def new
    @company = User.new
  end

  # Populates the edit page for company
  #
  def edit
    @company = User.find(params[:id])
  end

  # Show company and its products from admin view
  #
  def show
    @company = User.find(params[:id])
    @products = @company.products
  end

  # Store new company to db
  #
  def create
    @company = User.new(user_params)
    if @company.save
      activity_log("created a company <b>#{@company.first_name}</b>")
      redirect_to admin_index_path
    else
      render 'new'
    end
  end

  # Update the company details in db
  #
  def update
    @company = User.find(params[:id])
    if @company.update(user_params)
      redirect_to admin_index_path
    else
      render 'edit'
    end
  end

  # Delete a company
  #
  def destroy
    @company = User.find(params[:id])
    @company.destroy
    redirect_to admin_index_path
  end

  # Check whether the user is a company
  #
  def check_user
    redirect_to home_index_path unless current_user.role == COMPANY
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :role, :logo_id)
  end
end
