require 'rails_helper'

RSpec.describe "promos/edit", type: :view do
  before(:each) do
    @promo = assign(:promo, Promo.create!(
      :code => "MyString",
      :quantity => 1,
      :bonus => 1
    ))
  end

  it "renders the edit promo form" do
    render

    assert_select "form[action=?][method=?]", promo_path(@promo), "post" do

      assert_select "input#promo_code[name=?]", "promo[code]"

      assert_select "input#promo_quantity[name=?]", "promo[quantity]"

      assert_select "input#promo_bonus[name=?]", "promo[bonus]"
    end
  end
end
