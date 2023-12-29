require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'renders JSON with companies' do
      company = FactoryBot.create(:company)
      get :index
      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to be_an(Array)
      expect(parsed_response.first['name']).to eq(company.name)
      expect(parsed_response.first['location']).to eq(company.location)
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryBot.create(:user, :admin) }
    let(:company) { FactoryBot.create(:company) }
    before { sign_in user }

    it 'returns a successful response' do
      get :show, params: { id: company.id }
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['name']).to eq(company.name)
      expect(parsed_response['location']).to eq(company.location)
    end

    it 'requires admin role' do
      user.update(role: :user)
      post :show, params: { id: company.id }
      expect(response).to have_http_status(:unauthorized)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['error']).to eq('Unauthorized')
    end

    it 'returns not found for non-existing company' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['error']).to eq('Company not found')
    end
  end

  describe 'POST #create' do
    let(:user) { FactoryBot.create(:user, :admin) }
    let(:valid_attributes) { FactoryBot.attributes_for(:company) }

    before { sign_in user }

    it 'creates a new company' do
      expect do
        post :create, params: { company: valid_attributes }
      end.to change(Company, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns errors for invalid company data' do
      post :create, params: { company: { name: nil, location: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['errors']).to eq({ 'name' => ["can't be blank"], 'location' => ["can't be blank"] })
    end

    it 'requires admin role' do
      user.update(role: :user)
      post :create, params: { company: valid_attributes }
      expect(response).to have_http_status(:unauthorized)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['error']).to eq('Unauthorized')
    end
  end
end
