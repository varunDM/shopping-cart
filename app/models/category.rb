#
# Category model
#
# @author [qbuser]
#
class Category < ActiveRecord::Base
  has_many :products, dependent: :destroy
  validates :name, presence: true
end
