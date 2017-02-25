require 'rails_helper'

RSpec.describe "loots/index", type: :view do
  before(:each) do
    assign(:loots, [
      Loot.create!(),
      Loot.create!()
    ])
  end

  it "renders a list of loots" do
    render
  end
end
