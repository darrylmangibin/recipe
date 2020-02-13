require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

    def setup
        @chef = Chef.create!(name: "darryl", email:"darryl@gmail.com")
        @recipe = @chef.recipes.build(name: "Recipe 1", description: "this is a recipe test")
    end

    test "recipe should be valid" do
        assert @recipe.valid?
    end

    test "recipe without chef should be invalid" do
        @recipe.chef_id = nil
        assert_not @recipe.valid?
    end

    test "name should be present" do
        @recipe.name = ""
        assert_not @recipe.valid?
    end

    test "description should be present" do
        @recipe.description = ""
        assert_not @recipe.valid?
    end

    test "description should not be lss than 5 char" do
        @recipe.description = "a" * 3
        assert_not @recipe.valid?
    end

    test "description should not be more than 500 char" do
        @recipe.description = "a" * 501
        assert_not @recipe.valid?
    end
end