class CreateBillAddresses < ActiveRecord::Migration
  def change
    create_table :bill_addresses do |t|

      t.timestamps null: false
    end
  end
end
