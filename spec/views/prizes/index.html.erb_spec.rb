require 'rails_helper'

RSpec.describe "prizes/index", type: :view do
  before(:each) do
    assign(:prizes, [
      Prize.create!(),
      Prize.create!()
    ])
  end

  it "renders a list of prizes" do
    render
  end
end
