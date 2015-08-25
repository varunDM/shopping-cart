class AddQuantityToPurchaseProducts < ActiveRecord::Migration
  def change
    add_column :purchase_products, :quantity, :integer
  end
end
