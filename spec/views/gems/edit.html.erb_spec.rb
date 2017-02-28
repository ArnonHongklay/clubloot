require 'rails_helper'

RSpec.describe "gems/edit", type: :view do
  before(:each) do
    @gem = assign(:gem, Gem.create!())
  end

  it "renders the edit gem form" do
    render

    assert_select "form[action=?][method=?]", gem_path(@gem), "post" do
    end
  end
end
