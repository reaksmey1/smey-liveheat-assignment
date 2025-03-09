class Race < ApplicationRecord  
    validates :name, presence: true
    validates :number_of_lanes, numericality: { greater_than_or_equal_to: 2 }
end