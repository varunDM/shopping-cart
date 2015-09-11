require 'rails_helper'

RSpec.describe "home page", :type => :request do
  it "displays the user's username after successful login" do
    user = User.create!(:email => "jdoe@gmail.com", :first_name => "john Doe", :password => "secret")
    get "/users/sign_in"
    assert_select "form.login" do
      assert_select "input[name=?]", "username"
      assert_select "input[name=?]", "password"
      assert_select "input[type=?]", "submit"
    end

    post "/login", :username => "jdoe", :password => "secret"
    assert_select ".header .username", :text => "jdoe"
  end
end