#
# UserMailer
#
# @author [qbuser]
#
class UserMailer < ApplicationMailer
  default from: 'mailforvarundas@gmail.com'

  # Get purchase details
  #
  def purchase_email(purchase)
    @purchase = purchase
    @bill_address = BillAddress.find(purchase[:bill_address_id])
    @user = User.find(@bill_address.user_id)
    purchase_products = Purchase.find(purchase[:id]).purchase_products
    @products = []
    Array(purchase_products).each do |purchase_product|
      quantity = purchase_product[:quantity]
      product = Product.find(purchase_product[:product_id])
      @products << { name: product.name, price: product.price, quantity: quantity }
    end
    # attachments.inline['product.jpg'] = File.read(@product.avatar.url)
    mail(to: @user.email,
         subject: 'Purchase Successful !',
         template_path: 'user_mailer')
  end
end
