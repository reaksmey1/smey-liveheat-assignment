class Student < ApplicationRecord
    has_many :lanes
    has_many :races, through: :lanes
    
    validates :name, presence: true, uniqueness: true
end