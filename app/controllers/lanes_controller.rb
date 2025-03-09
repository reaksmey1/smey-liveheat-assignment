class LanesController < ApplicationController
    def create
        @race = Race.find(params[:race_id])
        lane_params = params.require(:lane).permit(:student_id, :lane_number)
    
        service = AssignLaneService.new(@race, lane_params)
        result = service.call
    
        if result[:success]
            redirect_to @race, notice: "Student assigned to lane successfully."
        else
            flash[:alert] = result[:message]
            redirect_to race_path(@race)
        end
    end
  
    private
  
    def lane_params
      params.require(:lane).permit(:student_id, :lane_number)
    end
end