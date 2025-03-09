# spec/controllers/races_controller_spec.rb
require 'rails_helper'

RSpec.describe RacesController, type: :controller do
  let(:valid_attributes) {
    { name: "Sprint Race", number_of_lanes: 4 }
  }

  let(:invalid_attributes) {
    { name: "", number_of_lanes: 0 }
  }

  let(:race) { Race.create(valid_attributes) }
  let(:lane_1) { Lane.create(race: race, student: Student.create(name: 'Student 1')) }
  let(:lane_2) { Lane.create(race: race, student: Student.create(name: 'Student 2')) }

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

        expect(response).to redirect_to(:new_race)
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

  describe 'GET #set_ranking' do
    it 'assigns the correct race to @race' do
      get :set_ranking, params: { id: race.id }
      expect(assigns(:race)).to eq(race)
    end
  end

  describe 'GET #set_ranking' do
    it 'assigns the correct race to @race' do
      get :set_ranking, params: { id: race.id }
      expect(assigns(:race)).to eq(race)
    end
  end

  describe 'POST #update_ranking' do
    context 'when rankings are valid' do
      let(:valid_ranking_params) do
        {
          "ranking_#{lane_1.id}" => 1,
          "ranking_#{lane_2.id}" => 2
        }
      end

      it 'calls the UpdateRankingService and redirects with success message' do
        service = instance_double(UpdateRankingService)
        allow(UpdateRankingService).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return({ success: true, message: 'Rankings updated successfully' })

        post :update_ranking, params: { id: race.id, **valid_ranking_params }

        expect(response).to redirect_to(set_ranking_race_path(race))
        expect(flash[:notice]).to eq('Rankings updated successfully')
      end
    end

    context 'when rankings are invalid' do
      let(:invalid_ranking_params) do
        {
          "ranking_#{lane_1.id}" => 1,
          "ranking_#{lane_2.id}" => 3,
          "ranking_#{lane_2.id}" => 2
        }
      end

      it 'returns an error message and redirects with alert' do
        service = instance_double(UpdateRankingService)
        allow(UpdateRankingService).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return({ success: false, message: 'Invalid ranking sequence. Please fix the gaps or ties.' })

        post :update_ranking, params: { id: race.id, **invalid_ranking_params }

        expect(response).to redirect_to(set_ranking_race_path(race))
        expect(flash[:alert]).to eq('Invalid ranking sequence. Please fix the gaps or ties.')
      end
    end
  end
end