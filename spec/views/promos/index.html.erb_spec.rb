require 'rails_helper'

RSpec.describe "promos/index", type: :view do
  before(:each) do
    assign(:promos, [
      Promo.create!(
        :code => "Code",
        :quantity => 2,
        :bonus => 3
      ),
      Promo.create!(
        :code => "Code",
        :quantity => 2,
        :bonus => 3
      )
    ])
  end

  it "renders a list of promos" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
