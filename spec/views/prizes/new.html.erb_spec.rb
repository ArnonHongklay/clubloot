require 'rails_helper'

RSpec.describe "prizes/new", type: :view do
  before(:each) do
    assign(:prize, Prize.new())
  end

  it "renders new prize form" do
    render

    assert_select "form[action=?][method=?]", prizes_path, "post" do
    end
  end
end
