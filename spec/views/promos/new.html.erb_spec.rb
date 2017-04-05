require 'rails_helper'

RSpec.describe "promos/new", type: :view do
  before(:each) do
    assign(:promo, Promo.new(
      :code => "MyString",
      :quantity => 1,
      :bonus => 1
    ))
  end

  it "renders new promo form" do
    render

    assert_select "form[action=?][method=?]", promos_path, "post" do

      assert_select "input#promo_code[name=?]", "promo[code]"

      assert_select "input#promo_quantity[name=?]", "promo[quantity]"

      assert_select "input#promo_bonus[name=?]", "promo[bonus]"
    end
  end
end
