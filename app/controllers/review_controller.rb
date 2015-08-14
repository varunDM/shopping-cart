#
class ReviewController < ApplicationController
  def create
    review = Review.new(review_params)
    if review.save
      redirect_to session[:previous_url]
    end
  end

  def review_params
    params.require(:review).permit(:body, :user_id, :product_id)
  end
end
