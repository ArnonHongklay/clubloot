require 'rails_helper'

RSpec.describe "Loots", type: :request do
  describe "GET /loots" do
    it "works! (now write some real specs)" do
      get loots_path
      expect(response).to have_http_status(200)
    end
  end
end
