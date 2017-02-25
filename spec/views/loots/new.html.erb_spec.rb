require 'rails_helper'

RSpec.describe "loots/new", type: :view do
  before(:each) do
    assign(:loot, Loot.new())
  end

  it "renders new loot form" do
    render

    assert_select "form[action=?][method=?]", loots_path, "post" do
    end
  end
end
