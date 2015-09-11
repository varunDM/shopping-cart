#
# [class description]
#
# @author [qbuser]
#
class Api::SessionsController < ApplicationController
  def create
    user = User.find_by_email(email: create_params[:email])
  end

  def create_params
    params.require(:user).permit(:email, :password)
  end
end
