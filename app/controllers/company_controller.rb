#
class CompanyController < ApplicationController
  before_action :authenticate_user!

  def index
    @company = current_user
    @products = @company.products
  end

  def new
    @company = User.new
  end

  def edit
    @company = User.find(params[:id])
  end

  def show
    @company = User.find(params[:id])
    @products = @company.products
  end

  def create
    @company = User.new(user_params)
    if @company.save
      redirect_to admin_index_path
    else
      render 'new'
    end
  end

  def update
    @company = User.find(params[:id])
    if @company.update(user_params)
      redirect_to admin_index_path
    else
      render 'edit'
    end
  end

  def destroy
    @company = User.find(params[:id])
    @company.destroy
    redirect_to admin_index_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :role, :logo_id)
  end

end
