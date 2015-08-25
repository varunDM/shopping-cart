#
class BillAddress < ActiveRecord::Base
  validates :name, presence: true
  validates :zip, presence: true
  validates :address, presence: true
  validates :country, presence: true
  validates :phone, presence: true

  belongs_to :user
  has_many :purchases, dependent: :destroy
end
