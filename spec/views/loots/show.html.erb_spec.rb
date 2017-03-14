require 'rails_helper'

RSpec.describe "loots/show", type: :view do
  before(:each) do
    @loot = assign(:loot, Loot.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
