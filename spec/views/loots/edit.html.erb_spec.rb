require 'rails_helper'

RSpec.describe "loots/edit", type: :view do
  before(:each) do
    @loot = assign(:loot, Loot.create!())
  end

  it "renders the edit loot form" do
    render

    assert_select "form[action=?][method=?]", loot_path(@loot), "post" do
    end
  end
end
