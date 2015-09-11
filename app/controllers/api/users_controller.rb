#
# API
#
# @author [qbuser]
#
class Api::UsersController < ApplicationController
  protect_from_forgery with: :null_session
  http_basic_authenticate_with :name => "demo", :password => "demo"
  before_filter :authenticate_user!
  before_filter :fetch_user, :except => [:index, :create]

  def fetch_user
    @user = User.find_by_id(params[:id])
  end

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def sign_in
    
  end
end
