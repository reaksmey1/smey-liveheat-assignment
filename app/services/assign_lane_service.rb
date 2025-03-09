class AssignLaneService
    def initialize(race, lane_params)
      @race = race
      @lane_params = lane_params
    end
  
    def call
      byebug
      # Check if the student is already assigned to another lane in the same race
      if student_already_assigned?
        return { success: false, message: "This student is already assigned to a lane in this race." }
      end
  
      # Check if the lane already has a student assigned
      if lane_already_assigned?
        return { success: false, message: "This lane is already assigned to another student." }
      end

      # Check if the lane number is within the valid range
      if !valid_lane_number?
        return { success: false, message: "Unable to assign the student to this lane." }
      end
  
      # Create the lane if all checks pass
      @lane = @race.lanes.build(@lane_params)
      if @lane.save
        return { success: true, lane: @lane }
      else
        return { success: false, message: "Unable to assign the student to this lane." }
      end
    end
  
    private
  
    def student_already_assigned?
      # Check if the student is already assigned to any lane in the current race
      @race.lanes.exists?(student_id: @lane_params[:student_id])
    end
  
    def lane_already_assigned?
      # Check if the lane already has a student assigned
      @race.lanes.exists?(lane_number: @lane_params[:lane_number])
    end

    def valid_lane_number?
        # Check if the lane number is within the valid range
        @lane_params[:lane_number].to_i.between?(1, @race.number_of_lanes)
    end
end