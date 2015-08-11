#
class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :description, presence: true
  
  # attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }#, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def self.search(query, type)
    Product.select('products.*, users.first_name as first_name').joins(:user).joins(:category).where(" #{type} like ? ", "%#{query}%")

  end


  def avatar_url
    avatar.url(:thumb)
  end
end
