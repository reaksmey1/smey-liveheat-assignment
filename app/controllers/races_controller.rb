class RacesController < ApplicationController
    def index
        @races = Race.all
    end

    def new
        @race = Race.new
    end
  
    def create
        @race = Race.new(race_params)
        if @race.save
            redirect_to @race, notice: "New race created successfully."
        else
            flash[:alert] = "Failed created race"
            redirect_to new_race_path
        end
    end
  
    def show
        @race = Race.find(params[:id])
    end

    def set_ranking
        @race = Race.find(params[:id])
    end

    def update_ranking
        @race = Race.find(params[:id])
    
        # Call the service to process the rankings
        service = UpdateRankingService.new(@race, params)
        result = service.call
        if result[:success]
          redirect_to set_ranking_race_path(@race), notice: result[:message]
        else
          flash[:alert] = result[:message]
          redirect_to set_ranking_race_path(@race)
        end
    end
  
    private
  
    def race_params
        params.require(:race).permit(:name, :number_of_lanes)
    end
end