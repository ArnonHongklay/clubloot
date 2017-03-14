require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #loot" do
    it "returns http success" do
      get :loot
      expect(response).to have_http_status(:success)
    end
  end

end
