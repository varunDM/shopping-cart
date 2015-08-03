# Adds the reference of category to product table
class AddCategoryRefToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :category, index: true
  end
end
