#
class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :purchase_products, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, :reject_if => lambda { |t| t['image'].nil? }

  validates :name, presence: true
  validates :price, presence: true, :numericality => { :only_integer => true }
  validates :quantity, presence: true, :numericality => { :only_integer => true }
  validates :description, presence: true

  def self.search(query, type)
    Product.select('products.*, users.first_name as first_name').joins(:user).joins(:category).where(" #{type} like ? ", "%#{query}%")

  end

  def self.autocomplete(query)
    @product = Product.select('products.name', 'products.id').where("name like ?", "%#{query}%")
    @category = Category.select('categories.name, categories.id').where("name like ?", "%#{query}%")
    { :category => @category, :product => @product }
  end

  def image_url
    product_images[0].image.url(:thumb)
  end
end
