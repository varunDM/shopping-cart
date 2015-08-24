class RemoveProductId < ActiveRecord::Migration
  def change
    remove_column :purchases, :product_id
  end
end
