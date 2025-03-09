require 'rails_helper'

RSpec.describe LanesController, type: :controller do
  let!(:race) { Race.create(name: 'Sprint Race', number_of_lanes: 4) }
  let!(:student) { Student.create(name: 'John Doe') }
  
  let(:valid_lane_params) {
    { student_id: student.id, lane_number: 1 }
  }

  let(:invalid_lane_params) {
    { student_id: student.id, lane_number: 5 } # assuming lane 5 doesn't exist in the race
  }

  describe 'POST #create' do
    context 'when the lane is successfully created' do
      it 'assigns the student to the lane and redirects to the race' do
        service = double("AssignLaneService")
        allow(AssignLaneService).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return({ success: true, lane: double("Lane") })

        post :create, params: { race_id: race.id, lane: valid_lane_params }

        expect(response).to redirect_to(race_path(race))
        expect(flash[:notice]).to eq("Student assigned to lane successfully.")
      end
    end

    context 'when the lane assignment fails' do
      it 'does not assign the student to the lane and redirects to the race with an error message' do
        service = double("AssignLaneService")
        allow(AssignLaneService).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return({ success: false, message: "Unable to assign the student to this lane." })

        post :create, params: { race_id: race.id, lane: invalid_lane_params }

        expect(response).to redirect_to(race_path(race))
        expect(flash[:alert]).to eq("Unable to assign the student to this lane.")
      end
    end
  end
end