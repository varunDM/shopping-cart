#
class UserMailer < ApplicationMailer
  default from: 'mailforvarundas@gmail.com'

  def purchase_email(params, session)

    if params[:product_id] == "0"
      bill_address = BillAddress.find(params[:bill_address_id])
      @user = User.find(bill_address.user_id)
      items = session
      @products = []
      items.each do |item|
        @products << Product.find(item['product'])
      end
    else

      bill_address = BillAddress.find(params[:bill_address_id])
      @user = User.find(bill_address.user_id)
      @products = Array(Product.find(params[:product_id]))

    end
    # attachments.inline['product.jpg'] = File.read(@product.avatar.url)
    mail(to: @user.email,
         subject: 'Purchase Successful !',
         template_path: 'user_mailer')
  end
end
