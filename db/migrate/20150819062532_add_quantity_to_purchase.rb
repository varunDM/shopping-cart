class AddQuantityToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :quantity, :integer
    add_column :purchases, :price, :integer
  end
end
