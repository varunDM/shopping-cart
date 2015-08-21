class AddIpToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :ip, :integer
  end
end
