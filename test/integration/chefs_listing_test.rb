require 'test_helper'

class ChefsListingTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chef_name: "mashrur", email: "mashrur@example.com",
                    password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chef_name: "john", email: "john@example.com",
                    password: "password", password_confirmation: "password")
		@admin_user = Chef.create!(chef_name: "john", email: "john2@example.com",
                    password: "password", password_confirmation: "password", admin: true)
  end
  
  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
  	assert_select "a[href=?]", chef_path(@chef), text: @chef.chef_name.capitalize
 	 	assert_select "a[href=?]", chef_path(@chef2), text: @chef2.chef_name.capitalize
  end
	
	test "should delete chef" do
		sign_in_as(@admin_user, "password")
		get chefs_path
		assert_template 'chefs/index'
		assert_difference 'Chef.count', -1 do 
			delete chef_path(@chef2)
		end
		assert_redirected_to chefs_path
		assert_not flash.empty?
	end
end
