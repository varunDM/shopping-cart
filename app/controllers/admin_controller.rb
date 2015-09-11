#
# Admin related actions
#
# @author [qbuser]
#
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user

  # Admin dashboard
  #
  def index
    @user = User.new
    @companies = User.where(role: COMPANY)
    @categories = Category.all
    @purchases = Purchase.all
    @customers = User.where(role: CUSTOMER).count

    @activities = ActivityLog.select('action', 'created_at', 'user_id')
                  .order(created_at: :desc)
                  .limit(8)

    @orders = Purchase.select('id', 'created_at', 'first_name')
              .joins(bill_address: :user)
              .order(created_at: :desc)
              .limit(7)
    @totals = []
    @orders.each do |order|
      sum = 0
      order.purchase_products.each do |product|
        sum += product.quantity * product.product.price
      end
      @totals << sum
    end
  end

  # Get all orders and amount
  #
  def view_orders
    @orders = Purchase.select('id', 'created_at', 'first_name', 'email', 'phone', 'ip')
              .joins(bill_address: :user)
              .order(created_at: :desc)
              .page params[:page]
    @totals = []
    @orders.each do |order|
      sum = 0
      order.purchase_products.each do |product|
        sum += product.quantity * product.product.price
      end
      @totals << sum
    end
  end

  def view_customers
    @customers = User.select('first_name', 'second_name', 'email', 'address', 'city', 'state').where(role: CUSTOMER)
                 .page params[:page]
  end

  # All activity logs
  #
  def logs
    @activities = ActivityLog.all.order(created_at: :desc).page params[:page]
  end

  # An order, its products, subtotal and shipping address
  #
  def order_details
    @order = Purchase.select('id', 'created_at', 'first_name', 'email', 'phone', 'ip')
             .joins(bill_address: :user).find(params[:id])
    @purchase_products = Purchase.find(params[:id]).purchase_products
    @total = 0
    @purchase_products.each do |purchase_product|
      @total += purchase_product.quantity * purchase_product.product.price
    end
    @shipping = Purchase.find(params[:id]).bill_address
  end

  # Check whether the user is admin or not
  #
  def check_user
    redirect_to home_index_path unless current_user.role == SUPERADMIN
  end
end
