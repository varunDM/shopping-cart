#
class ReviewController < ApplicationController
  def create
    review = Review.new(review_params)
    redirect_to session[:previous_url] if review.save
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to session[:previous_url]
  end

  def review_params
    params.require(:review).permit(:body, :user_id, :product_id)
  end
end
