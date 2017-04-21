require 'rails_helper'

RSpec.describe "adverts/edit", type: :view do
  before(:each) do
    @advert = assign(:advert, Advert.create!(
      :description => "MyString"
    ))
  end

  it "renders the edit advert form" do
    render

    assert_select "form[action=?][method=?]", advert_path(@advert), "post" do

      assert_select "input#advert_description[name=?]", "advert[description]"
    end
  end
end
