class AddForiegnKeyUserToBillAddress < ActiveRecord::Migration
  def change
    add_reference :bill_addresses, :user, index: true
  end
end
