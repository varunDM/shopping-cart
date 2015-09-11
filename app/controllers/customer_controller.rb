#
# Customer related activities
#
# @author [qbuser]
#
class CustomerController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user

  # Customer dashboard
  #
  def index
    @user = User.select('id', 'first_name', 'second_name', 'email', 'address', 'city', 'state', 'zip')
            .find(current_user.id)
    @purchases = []
    @user.bill_addresses.each do |bill|
      @purchases = bill.purchases
    end
  end

  # Create a bill address from check out view
  #
  def create_bill_address
    @address = BillAddress.new(address_params)
    @address.save
    redirect_to session[:check_out_url]
  end

  # Remove a bill address from check out view
  #
  def remove_bill_address
    @address = BillAddress.find(params[:address_id])
    @address.destroy
    redirect_to session[:check_out_url]
  end

  # Check whether the user is a customer or not
  #
  def check_user
    redirect_to home_index_path unless current_user.role == CUSTOMER
  end

  private

  def address_params
    params.require(:bill_address).permit(:name, :zip, :address, :country, :phone, :user_id)
  end
end
