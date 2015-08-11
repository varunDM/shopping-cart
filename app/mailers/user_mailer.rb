#
class UserMailer < ApplicationMailer
  default from: 'mailforvarundas@gmail.com'

  def purchase_email(purchase)
    @user = User.find(purchase.bill_address.user_id)
    @product = Product.find(purchase.product_id)
    # attachments.inline['product.jpg'] = File.read(@product.avatar.url)
    mail(to: @user.email,
         subject: 'Purchase Successful !',
         template_path: 'user_mailer')
  end
end
