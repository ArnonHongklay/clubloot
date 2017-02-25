require "rails_helper"

RSpec.describe LootsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/loots").to route_to("loots#index")
    end

    it "routes to #new" do
      expect(:get => "/loots/new").to route_to("loots#new")
    end

    it "routes to #show" do
      expect(:get => "/loots/1").to route_to("loots#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/loots/1/edit").to route_to("loots#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/loots").to route_to("loots#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/loots/1").to route_to("loots#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/loots/1").to route_to("loots#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/loots/1").to route_to("loots#destroy", :id => "1")
    end

  end
end
