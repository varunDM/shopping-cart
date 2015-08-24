class DeleteProductidFromPurchases < ActiveRecord::Migration
  def change
    #execute("ALTER TABLE `purchases` DROP `product_id`")
    remove_foreign_key :purchases, :column => :product_id
  end
end
