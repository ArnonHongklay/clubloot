require 'rails_helper'

RSpec.describe "gems/new", type: :view do
  before(:each) do
    assign(:gem, Gem.new())
  end

  it "renders new gem form" do
    render

    assert_select "form[action=?][method=?]", gems_path, "post" do
    end
  end
end
