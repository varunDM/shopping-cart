class ChangeDataTypesOfBillAddress < ActiveRecord::Migration
  def change
    change_column :bill_addresses, :zip, :string
    change_column :bill_addresses, :phone, :string
  end
end
