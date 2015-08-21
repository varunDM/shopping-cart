class Purchase < ActiveRecord::Base
  paginates_per 10  
  belongs_to :bill_address
  belongs_to :product
end
