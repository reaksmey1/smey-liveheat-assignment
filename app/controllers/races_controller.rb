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
        redirect_to @race
        else
        render :new
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