class Race < ApplicationRecord
    has_many :lanes
    has_many :students, through: :lanes

    validates :name, presence: true
    validates :number_of_lanes, numericality: { greater_than_or_equal_to: 2 }
end