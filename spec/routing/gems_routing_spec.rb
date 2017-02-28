require "rails_helper"

RSpec.describe GemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/gems").to route_to("gems#index")
    end

    it "routes to #new" do
      expect(:get => "/gems/new").to route_to("gems#new")
    end

    it "routes to #show" do
      expect(:get => "/gems/1").to route_to("gems#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/gems/1/edit").to route_to("gems#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/gems").to route_to("gems#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/gems/1").to route_to("gems#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/gems/1").to route_to("gems#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/gems/1").to route_to("gems#destroy", :id => "1")
    end

  end
end
