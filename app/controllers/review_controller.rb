#
class ReviewController < ApplicationController
  def create
    review = Review.find(review_params)
    
  end

  def review_params
    params.require(:review).permit(:body, :user_id, :product_id)
  end
end
