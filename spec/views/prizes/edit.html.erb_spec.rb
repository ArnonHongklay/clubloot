require 'rails_helper'

RSpec.describe "prizes/edit", type: :view do
  before(:each) do
    @prize = assign(:prize, Prize.create!())
  end

  it "renders the edit prize form" do
    render

    assert_select "form[action=?][method=?]", prize_path(@prize), "post" do
    end
  end
end
