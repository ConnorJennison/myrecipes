require 'test_helper'

class ChefTest < ActiveSupport::TestCase
	def setup
		@chef = Chef.new(chef_name: "Connor", email: "connor@example.com", password: "password", password_confirmation: "password")
	end
	
	test "chef must be valid" do
		assert @chef.valid?
	end
	
	test "name should be present" do
		@chef.chef_name = ""
		assert_not @chef.valid?
	end
	
	test "email should be present" do
		@chef.email = ""
		assert_not @chef.valid?
	end
	
	test "name should be less than 30 characters" do
		@chef.chef_name = "a" * 31
		assert_not @chef.valid?
	end
	
	test "email should not be too long" do
		@chef.email = "a" * 245 + "@example.com"
		assert_not @chef.valid?
	end
	
	test "email address should be valid format" do
		valid_emails = %w[user@example.com MARSHRUR@gmail.com M.first@yahoo.ca john+smith@co.uk.org]
		valid_emails.each do |valids|
			@chef.email = valids
			assert @chef.valid? "#{valids.inspect} should be valid"
		end
	end
		
	test "should reject invalid emails" do
		invalid_emails = %w[marshur@example mashrur@example,com marshrur.name@gmail. joe@bar+foo.com]
		invalid_emails.each do |invalids|
			@chef.email = invalids
			assert_not @chef.valid? "#{invalids.inspect} should be invalid"
		end
	end
	
	test "email should be unique and case insensitive" do 
		duplicate_chef = @chef.dup
		duplicate_chef.email = @chef.email.upcase
		@chef.save
		assert_not duplicate_chef.valid?
	end
	
	test "email should be lowercase before hitting db" do 
		mixed_email = "JohN@exAMPlE.cOM"
		@chef.email = mixed_email
		@chef.save
		assert_equal mixed_email.downcase, @chef.reload.email
	end
	
	test "password should be present" do
		@chef.password = @chef.password_confirmation = " "
		assert_not @chef.valid?
	end
	
	test "password should be at least 5 characters" do
		@chef.password = @chef.password_confirmation = "a" * 4
		assert_not @chef.valid?
	end
	
end