require 'rails_helper'

RSpec.describe "gems/index", type: :view do
  before(:each) do
    assign(:gems, [
      Gem.create!(),
      Gem.create!()
    ])
  end

  it "renders a list of gems" do
    render
  end
end
