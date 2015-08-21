#
class CategoriesController < ApplicationController
  before_action :authenticate_user!
  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      activity_log("created <b>#{@category.name}</b> category")
      redirect_to admin_index_path
    else
      render 'new'
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      activity_log("updated category name <b>#{@category.previous_changes()['name'][0]}</b> to <b>#{@category.name}</b> ")
      redirect_to admin_index_path
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    activity_log("deleted <b>#{@category.name}</b> category ")
    @category.destroy
    redirect_to admin_index_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
