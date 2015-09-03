# For Customers
#
class CustomerController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user

  # /customer
  def index
    @user = User.select('id', 'first_name', 'second_name', 'email', 'address', 'city', 'state', 'zip')
                .find(current_user.id)
    @purchases = []
    @user.bill_addresses.each do |bill|
      @purchases = bill.purchases
    end
  end

  #
  def create_bill_address
    @address = BillAddress.new(address_params)
    @address.save
    redirect_to session[:check_out_url]
  end

  def remove_bill_address
    @address = BillAddress.find(params[:address_id])
    @address.destroy
    redirect_to session[:check_out_url]
  end

  def check_user
    redirect_to home_index_path unless current_user.role == CUSTOMER
  end

  private

  def address_params
    params.require(:bill_address).permit(:name, :zip, :address, :country, :phone, :user_id)
  end
end
