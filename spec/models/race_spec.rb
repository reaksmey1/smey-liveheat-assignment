require 'rails_helper'

RSpec.describe Race, type: :model do
    it { should have_many(:lanes) }
    it { should have_many(:students).through(:lanes) }
    
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:number_of_lanes).is_greater_than_or_equal_to(2) }
end