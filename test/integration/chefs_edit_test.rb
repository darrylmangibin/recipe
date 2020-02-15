require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @chef = Chef.create!(name: "mangibin", email: "mangibin@example.com", password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(name: "ld", email: "ld@example.com", password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(name: "mangibin1", email: "mangibin@example1.com", password: "password", password_confirmation: "password", admin: true)
  end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { name: " ", email: "mangibin1@example.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { name: "mangibin11", email: "mangibin11@example.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "mangibin11", @chef.name
    assert_match "mangibin11@example.com", @chef.email
  end

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { name: "mangibin111", email: "mangibin111@example.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "mangibin111", @chef.name
    assert_match "mangibin111@example.com", @chef.email
  end

  test "redirect edit attempt ny admother non-admin user" do
    sign_in_as(@chef2, "password")
    update_name = "ho"
    update_email = "dasda@dasd.com"
    patch chef_path(@chef), params: { chef: { name: update_name, email: update_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "mangibin", @chef.name
    assert_match "mangibin@example.com", @chef.email
  end
end
