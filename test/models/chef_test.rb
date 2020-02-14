require 'test_helper'

class ChefTest < ActiveSupport::TestCase
    def setup
        @chef = Chef.new(name: "darryl", email: "darryl.mangibin@gmail.com", password: "password", password_confirmation: "password")
    end

    test "should be valid" do
        assert @chef.valid?
    end
    
    test "name should be present" do
        @chef.name = ""
        assert_not @chef.valid?
    end

    test "name should be less than 30 characters" do
        @chef.name = "a" * 31
        assert_not @chef.valid?
    end

    test "email should be present" do 
        @chef.email = ""
        assert_not @chef.valid?
    end

    test "email should be be too long" do
        @chef.email = "2" * 256
        assert_not @chef.valid?
    end

    test "email should be correct format" do
        valid_emails = %w[user@gmail.com darryl@gmail.com]
        valid_emails.each do |valids|
            @chef.email = valids
            assert @chef.valid?, "#{valids.inspect} shold be valid" 
        end
    end
    
    test "should reject invalid email" do
        invalid_emails = %w[darryl.com darryl@gamil]
        invalid_emails.each do |invalids|
            @chef.email = invalids
            assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
        end
    end

    test "email should be unique and case insensitive" do
        duplicate_chef = @chef.dup
        duplicate_chef.email = @chef.email.upcase
        @chef.save
        assert_not duplicate_chef.valid?
    end

    test "email should be lower case before hitting db" do
        mixed_email = "JohN@ExampLe.com"
        @chef.email = mixed_email
        @chef.save
        assert_equal mixed_email.downcase, @chef.reload.email 
    end

    test "password should be present" do
        @chef.password = @chef.password_confirmation = " "
        assert_not @chef.valid?
    end
      
    test "password should be atleast 5 character" do
        @chef.password = @chef.password_confirmation = "x" * 4
        assert_not @chef.valid?
    end
end