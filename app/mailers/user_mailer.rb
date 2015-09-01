#
class UserMailer < ApplicationMailer
  default from: 'mailforvarundas@gmail.com'

  def purchase_email(check, purchase, session)

    @purchase = purchase
    if check == "cart"
      p 'ccccccccccaaaaaarttttttttttt'
      @bill_address = BillAddress.find(purchase[:bill_address_id])
      @user = User.find(@bill_address.user_id)
      # items = session
      # @products = []
      # items.each do |item|
      #   product = Product.find(item['product'])

      # end
      @products = []

      purchase_products = Purchase.find(purchase[:id]).purchase_products
      purchase_products.each do |purchase_product|
        quantity = purchase_product[:quantity]
        product = Product.find(purchase_product[:product_id])
        @products << {:name => product.name, :price => product.price, :quantity => quantity}
      end
    else
      p 'buyyyyyyyyyyyyyyyyyyyyyy'
      @bill_address = BillAddress.find(purchase[:bill_address_id])
      @user = User.find(@bill_address.user_id)
      @products = []
      purchase_product = Purchase.find(purchase[:id]).purchase_products
      Array(purchase_products).each do |purchase_product|
        quantity = purchase_product[:quantity]
        product = Product.find(purchase_product[:product_id])
        @products << {:name => product.name, :price => product.price, :quantity => quantity}
      end

    end
    # attachments.inline['product.jpg'] = File.read(@product.avatar.url)
    mail(to: @user.email,
         subject: 'Purchase Successful !',
         template_path: 'user_mailer')
  end
end
