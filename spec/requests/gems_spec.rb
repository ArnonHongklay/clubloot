require 'rails_helper'

RSpec.describe "Gems", type: :request do
  describe "GET /gems" do
    it "works! (now write some real specs)" do
      get gems_path
      expect(response).to have_http_status(200)
    end
  end
end
