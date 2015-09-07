#
class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :purchase_products, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :product_images, dependent: :destroy
  # validate :check_product_images
  accepts_nested_attributes_for :product_images, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :price, presence: true, :numericality => { :only_integer => true }
  validates :quantity, presence: true, :numericality => { :only_integer => true }
  validates :description, presence: true
  validates_associated :product_images

  def self.search(query, type)
    query = select('products.*, users.first_name as first_name').joins(:user)
           .joins(:category).where(" #{type} like ? ", "%#{query}%")
    query       
  end

  def self.autocomplete(query)
    @product = Product.select('products.name', 'products.id').where("name like ?", "%#{query}%")
    @category = Category.select('categories.name, categories.id').where("name like ?", "%#{query}%")
    { :category => @category, :product => @product }
  end

  # def check_product_images
  #   if self.product_images.size < 1 || self.product_images.all?{|pro| task.marked_for_destruction? }
  #     errors[:base]("A list must have at least one task.")
  #   end
  # end

  def image_url
    product_images[0].image.url(:thumb)
  end
end
