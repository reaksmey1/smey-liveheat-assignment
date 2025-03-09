require 'rails_helper'

RSpec.describe Student, type: :model do
    it 'is valid with a name' do
        student = Student.new(name: 'John Doe')
        expect(student).to be_valid
    end

    it 'is invalid without a name' do
        student = Student.new(name: nil)
        expect(student).to_not be_valid
        expect(student.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
        Student.create(name: 'John Doe')

        student = Student.new(name: 'John Doe')
        expect(student).to_not be_valid
        expect(student.errors[:name]).to include('has already been taken')
    end
end