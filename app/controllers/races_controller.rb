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
  
    private
  
    def race_params
        params.require(:race).permit(:name, :number_of_lanes)
    end
end