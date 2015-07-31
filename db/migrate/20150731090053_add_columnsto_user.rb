class AddColumnstoUser < ActiveRecord::Migration
  def change
  	add_column :users, :first_name, :string
    add_column :users, :second_name, :string
    add_column :users, :role, :integer
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
  end
end
