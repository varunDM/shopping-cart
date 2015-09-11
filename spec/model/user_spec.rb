require "rails_helper"

RSpec.describe User, :type => :model do
  it "orders by second_name" do
    lindeman = User.create!(first_name: "Andy", second_name: "Lindeman", email: "mailforvarundas@gmail.com", password: "iambatman")
    chelimsky = User.create!(first_name: "David", second_name: "Chelimsky", email: "varundasm.vdm@gmail.com", password: "iambatman")
  end
end