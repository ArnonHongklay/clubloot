require 'rails_helper'

RSpec.describe "adverts/index", type: :view do
  before(:each) do
    assign(:adverts, [
      Advert.create!(
        :description => "Description"
      ),
      Advert.create!(
        :description => "Description"
      )
    ])
  end

  it "renders a list of adverts" do
    render
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
