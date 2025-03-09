require 'rails_helper'

RSpec.describe AssignLaneService, type: :service do
  let(:race) { Race.create(name: "Sprint Race", number_of_lanes: 5) }
  let(:student) { Student.create(name: "John Doe") }

  describe '#call' do
    context 'when the student is already assigned to a lane in the same race' do
      before do
        race.lanes.create!(student: student, lane_number: 1)
      end

      it 'returns an error message' do
        lane_params = { student_id: student.id, lane_number: 2 }
        service = AssignLaneService.new(race, lane_params)

        result = service.call

        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq("This student is already assigned to a lane in this race.")
      end
    end

    context 'when the lane is already assigned to another student' do
      before do
        race.lanes.create!(student: student, lane_number: 1)
      end

      it 'returns an error message' do
        new_student = Student.create(name: "Jane Doe")
        lane_params = { student_id: new_student.id, lane_number: 1 }
        service = AssignLaneService.new(race, lane_params)

        result = service.call

        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq("This lane is already assigned to another student.")
      end
    end

    context 'when the student is successfully assigned to an available lane' do
      it 'creates the lane and assigns the student' do
        lane_params = { student_id: student.id, lane_number: 3 }
        service = AssignLaneService.new(race, lane_params)

        result = service.call

        expect(result[:success]).to be_truthy
        expect(result[:lane]).to be_a(Lane)
        expect(result[:lane].student).to eq(student)
        expect(result[:lane].lane_number).to eq(3)
      end
    end
  end
end