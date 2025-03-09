require 'rails_helper'

RSpec.describe UpdateRankingService, type: :service do
  let!(:race) { Race.create(name: "Sprint Race", number_of_lanes: 5) }
  let!(:student_1) { Student.create(name: "John") }
  let!(:student_2) { Student.create(name: "Jane") }
  let!(:student_3) { Student.create(name: "Mike") }
  let!(:student_4) { Student.create(name: "Sarah") }
  let!(:student_5) { Student.create(name: "Alice") }

  let!(:lane_1) { Lane.create(race: race, student: student_1) }
  let!(:lane_2) { Lane.create(race: race, student: student_2) }
  let!(:lane_3) { Lane.create(race: race, student: student_3) }
  let!(:lane_4) { Lane.create(race: race, student: student_4) }
  let!(:lane_5) { Lane.create(race: race, student: student_5) }

  describe '#call' do
    context 'when rankings are valid' do
      it 'updates the lanes with valid rankings' do
        ranking_params = {
          "ranking_#{lane_1.id}" => 1,
          "ranking_#{lane_2.id}" => 2,
          "ranking_#{lane_3.id}" => 3,
          "ranking_#{lane_4.id}" => 4,
          "ranking_#{lane_5.id}" => 5
        }

        service = UpdateRankingService.new(race, ranking_params)
        result = service.call

        expect(result[:success]).to be(true)
        expect(result[:message]).to eq("Rankings updated successfully")

        lane_1.reload
        lane_2.reload
        lane_3.reload
        lane_4.reload
        lane_5.reload

        expect(lane_1.ranking).to eq(1)
        expect(lane_2.ranking).to eq(2)
        expect(lane_3.ranking).to eq(3)
        expect(lane_4.ranking).to eq(4)
        expect(lane_5.ranking).to eq(5)
      end
    end

    context 'when rankings have gaps' do
      it 'returns an error message' do
        ranking_params = {
          "ranking_#{lane_1.id}" => 1,
          "ranking_#{lane_2.id}" => 2,
          "ranking_#{lane_3.id}" => 4,  # Invalid, because 3 is skipped
          "ranking_#{lane_4.id}" => 5,
          "ranking_#{lane_5.id}" => 6
        }

        service = UpdateRankingService.new(race, ranking_params)
        result = service.call

        expect(result[:success]).to be(false)
        expect(result[:message]).to eq("Invalid ranking sequence. Please fix the gaps or ties.")
      end
    end

    context 'when rankings have ties' do
      it 'updates the lanes with tied rankings' do
        ranking_params = {
          "ranking_#{lane_1.id}" => 1,
          "ranking_#{lane_2.id}" => 1,  # Tie for 1st place
          "ranking_#{lane_3.id}" => 3,  # The next available rank should be 3
          "ranking_#{lane_4.id}" => 4,
          "ranking_#{lane_5.id}" => 5
        }

        service = UpdateRankingService.new(race, ranking_params)
        result = service.call

        expect(result[:success]).to be(true)
        expect(result[:message]).to eq("Rankings updated successfully")

        lane_1.reload
        lane_2.reload
        lane_3.reload
        lane_4.reload
        lane_5.reload

        expect(lane_1.ranking).to eq(1)
        expect(lane_2.ranking).to eq(1)
        expect(lane_3.ranking).to eq(3)
        expect(lane_4.ranking).to eq(4)
        expect(lane_5.ranking).to eq(5)
      end
    end

    context 'when rankings are invalid due to ties with gaps' do
      it 'returns an error message' do
        ranking_params = {
          "ranking_#{lane_1.id}" => 1,
          "ranking_#{lane_2.id}" => 1,
          "ranking_#{lane_3.id}" => 2,  # Invalid, because 3 should be skipped
          "ranking_#{lane_4.id}" => 4,
          "ranking_#{lane_5.id}" => 5
        }

        service = UpdateRankingService.new(race, ranking_params)
        result = service.call

        expect(result[:success]).to be(false)
        expect(result[:message]).to eq("Invalid ranking sequence. Please fix the gaps or ties.")
      end
    end
  end
end