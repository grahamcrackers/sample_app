# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

	#before the test, instantiate the user to equal new user object
	before do 
		@user = User.new(name: "Example User", email: "user@example.com") 
	end

	subject { @user }

	#test 1: user should respond to :name
	it { should respond_to(:name) }
	#test 2: user should respond to :email
	it { should respond_to(:email) }

	#test 3: user object should be valid
	it { should be_valid }

	#test 4: when name is not present user should not be valid
	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	#test 5: when email is not present, user should not be valid
	describe "when name is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end
	#test 6: when a name is too long, user should not be valid
	describe "when a name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	#test 7: invalid email formats
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
							foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	#test 8: valid email formats
	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	#test 8: email must be unique
	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end
end
