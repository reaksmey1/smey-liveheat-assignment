require 'rails_helper'

RSpec.describe Lane, type: :model do
  it { should belong_to(:race) }
  it { should belong_to(:student) }
end