class UpdateRankingService
    def initialize(race, ranking_params)
      @race = race
      @ranking_params = ranking_params
    end
  
    def call
      rankings = process_rankings(@ranking_params)
  
      if valid_rankings?(rankings.sort)
        update_lanes(rankings)
        { success: true, message: "Rankings updated successfully" }
      else
        { success: false, message: "Invalid ranking sequence. Please fix the gaps or ties." }
      end
    end
  
    private
  
    def process_rankings(ranking_params)
      rankings = []
      @race.lanes.each do |lane|
        ranking = ranking_params["ranking_#{lane.id}"]
        rankings << ranking.to_i if ranking.present?
      end
      rankings
    end
  
    def valid_rankings?(rankings)
        sorted_rankings = rankings.sort
        last_rank = nil
        tied_count = 0
        expected_rank = 1
      
        sorted_rankings.each_with_index do |ranking, index|
          if ranking == last_rank
            # If it's the same rank as the previous one, it's a tie
            tied_count += 1
          else
            # Check if we are skipping ranks correctly
            if tied_count > 0
              expected_rank += tied_count
            end
      
            # Ensure there are no gaps in the sequence
            return false unless ranking == expected_rank
      
            # Reset for the next rank
            last_rank = ranking
            tied_count = 0
          end
      
          # The next expected rank should be incremented
          expected_rank += 1 unless tied_count > 0
        end
      
        true
    end
  
    def update_lanes(rankings)
      # Update lanes with the processed and validated rankings
      @race.lanes.each_with_index do |lane, index|
        lane.update(ranking: rankings[index])
      end
    end
end