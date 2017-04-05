require 'rails_helper'

RSpec.describe "promos/show", type: :view do
  before(:each) do
    @promo = assign(:promo, Promo.create!(
      :code => "Code",
      :quantity => 2,
      :bonus => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
