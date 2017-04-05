require "rails_helper"

RSpec.describe PromosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/promos").to route_to("promos#index")
    end

    it "routes to #new" do
      expect(:get => "/promos/new").to route_to("promos#new")
    end

    it "routes to #show" do
      expect(:get => "/promos/1").to route_to("promos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/promos/1/edit").to route_to("promos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/promos").to route_to("promos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/promos/1").to route_to("promos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/promos/1").to route_to("promos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/promos/1").to route_to("promos#destroy", :id => "1")
    end

  end
end
