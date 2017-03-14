require "rails_helper"

RSpec.describe PrizesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/prizes").to route_to("prizes#index")
    end

    it "routes to #new" do
      expect(:get => "/prizes/new").to route_to("prizes#new")
    end

    it "routes to #show" do
      expect(:get => "/prizes/1").to route_to("prizes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/prizes/1/edit").to route_to("prizes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/prizes").to route_to("prizes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/prizes/1").to route_to("prizes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/prizes/1").to route_to("prizes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/prizes/1").to route_to("prizes#destroy", :id => "1")
    end

  end
end
