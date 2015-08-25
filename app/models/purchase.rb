class Purchase < ActiveRecord::Base
  paginates_per 10
  belongs_to :bill_address
  has_many :purchase_products
  has_many :products, through: :purchase_products
end
