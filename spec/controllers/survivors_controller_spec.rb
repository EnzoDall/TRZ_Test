# spec/controllers/survivors_controller_spec.rb

require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new Survivor' do
      expect {
        post :create, params: { survivor: { name: "New Survivor", age: 32, gender: "Male", latitude: 0.0, longitude: 0.0 } }
      }.to change(Survivor, :count).by(1)
    end
  end

  describe 'PUT #update' do
    let(:survivor) { Survivor.create(name: "Update Test", age: 34, gender: "Female", latitude: 0.0, longitude: 0.0) }

    it 'updates the requested survivor' do
      put :update, params: { id: survivor.to_param, survivor: { name: "Updated Name" } }
      survivor.reload
      expect(survivor.name).to eq("Updated Name")
    end
  end
end
