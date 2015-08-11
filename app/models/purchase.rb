class Purchase < ActiveRecord::Base
  belongs_to :bill_address
  belongs_to :product
end
