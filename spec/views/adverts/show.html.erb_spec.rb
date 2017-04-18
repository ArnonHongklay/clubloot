require 'rails_helper'

RSpec.describe "adverts/show", type: :view do
  before(:each) do
    @advert = assign(:advert, Advert.create!(
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
  end
end
