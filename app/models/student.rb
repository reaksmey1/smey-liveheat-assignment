class Student < ApplicationRecord
    validates :name, presence: true, uniqueness: true
end