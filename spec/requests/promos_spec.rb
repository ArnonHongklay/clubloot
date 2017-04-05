require 'rails_helper'

RSpec.describe "Promos", type: :request do
  describe "GET /promos" do
    it "works! (now write some real specs)" do
      get promos_path
      expect(response).to have_http_status(200)
    end
  end
end
