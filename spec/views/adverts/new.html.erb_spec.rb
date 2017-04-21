require 'rails_helper'

RSpec.describe "adverts/new", type: :view do
  before(:each) do
    assign(:advert, Advert.new(
      :description => "MyString"
    ))
  end

  it "renders new advert form" do
    render

    assert_select "form[action=?][method=?]", adverts_path, "post" do

      assert_select "input#advert_description[name=?]", "advert[description]"
    end
  end
end
