require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
 
	def setup
		@chef = Chef.create!(chef_name: "connor", email: "connorjennison@me.com", password: "password", password_confirmation: "password")
		@chef2 = Chef.create!(chef_name: "connor", email: "connorjennison1@me.com", password: "password", password_confirmation: "password")
		@admin_user = Chef.create!(chef_name: "connor", email: "connorjennison2@me.com", password: "password", password_confirmation: "password", admin: true)
	end
	
	test "reject an invalid edit" do
		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chef_name: " ", email: "connorjennison@me.com"}}
		assert_template 'chefs/edit'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end
	
	test "accept valid edit" do 
		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chef_name: "hkfjhsdkjfh", email: "fdsafadsfdsf@me.com"}}
		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match @chef.email, "fdsafadsfdsf@me.com"
		assert_match @chef.chef_name, "hkfjhsdkjfh"
	end
	
	test "accept edit attempt by admin user" do
		sign_in_as(@admin_user, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chef_name: "hkfjhsdkjfh", email: "fdsafadsfdsf@me.com"}}
		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match @chef.email, "fdsafadsfdsf@me.com"
		assert_match @chef.chef_name, "hkfjhsdkjfh"
	end
	
	test "redirect edit attmept by another non-admin user" do 
		sign_in_as(@chef2, "password")
		updated_name = "jdfkljdslk"
		updated_email = "jfdklsfjlksdj@example.com"
		patch chef_path(@chef), params: { chef: { chef_name: updated_name, email: updated_email}}
		assert_redirected_to chefs_path
		assert_not flash.empty?
		@chef.reload
		assert_match @chef.email, "connorjennison@me.com"
		assert_match @chef.chef_name, "connor"
	end
end
