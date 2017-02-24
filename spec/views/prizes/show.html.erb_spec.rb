require 'rails_helper'

RSpec.describe "prizes/show", type: :view do
  before(:each) do
    @prize = assign(:prize, Prize.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
