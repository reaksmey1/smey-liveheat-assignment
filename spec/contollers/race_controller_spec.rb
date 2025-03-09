require 'rails_helper'

RSpec.describe RacesController, type: :controller do
  let(:valid_attributes) {
    { name: "Sprint Race", number_of_lanes: 4 }
  }

  let(:invalid_attributes) {
    { name: "", number_of_lanes: 0 }
  }

  let(:race) { Race.create(valid_attributes) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
      expect(assigns(:races)).to eq([race])
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
      expect(assigns(:race)).to be_a_new(Race)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Race and redirects to the show page' do
        expect {
          post :create, params: { race: valid_attributes }
        }.to change(Race, :count).by(1)

        expect(response).to redirect_to(Race.last)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Race and re-renders the new template' do
        expect {
          post :create, params: { race: invalid_attributes }
        }.to change(Race, :count).by(0)

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    it 'returns a successful response and assigns the requested race' do
      get :show, params: { id: race.id }
      expect(response).to be_successful
      expect(assigns(:race)).to eq(race)
    end
  end
end