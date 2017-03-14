require 'rails_helper'

RSpec.describe "gems/show", type: :view do
  before(:each) do
    @gem = assign(:gem, Gem.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
