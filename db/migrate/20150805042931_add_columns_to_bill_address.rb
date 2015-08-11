class AddColumnsToBillAddress < ActiveRecord::Migration
  def change
    add_column :bill_addresses, :name, :string
    add_column :bill_addresses, :zip, :integer
    add_column :bill_addresses, :address, :text
    add_column :bill_addresses, :country, :string
    add_column :bill_addresses, :phone, :integer
  end
end
