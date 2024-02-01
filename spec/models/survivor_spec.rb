# spec/models/survivor_spec.rb

require 'rails_helper'

RSpec.describe Survivor, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      survivor = Survivor.new(name: "Enzo", age: 21, gender: "Male", latitude: 0.0, longitude: 0.0)
      expect(survivor).to be_valid
    end

    it 'is not valid without a name' do
      survivor = Survivor.new(age: 22, gender: "Male", latitude: 0.0, longitude: 0.0)
      expect(survivor).not_to be_valid
      expect(survivor.errors.messages[:name]).to include("can't be blank")
    end

    # Adicione mais testes de validação conforme necessário
  end
  context 'updating location' do
    let(:survivor) { Survivor.create(name: "Maria", age: 28, gender: "Female", latitude: 0.0, longitude: 0.0) }

    it 'updates latitude and longitude' do
      survivor.update(latitude: 1.0, longitude: 1.0)
      expect(survivor.latitude).to eq(1.0)
      expect(survivor.longitude).to eq(1.0)
    end
  end

  context 'reporting infection' do
    let(:survivor) { Survivor.create(name: "Maria", age: 28, gender: "Female", latitude: 0.0, longitude: 0.0) }

    it 'increments infection reports' do
      expect { survivor.increment!(:infection_reports) }.to change(survivor, :infection_reports).by(1)
    end
  end

  context 'when reporting infection' do
    let(:survivor) { Survivor.create(name: "Test Survivor", age: 30, gender: "Non-binary", latitude: 0.0, longitude: 0.0) }

    it 'increases infection report count' do
      initial_count = survivor.infection_reports
      survivor.increment!(:infection_reports)
      expect(survivor.infection_reports).to eq(initial_count + 1)
    end

    it 'marks survivor as infected when reports reach threshold' do
      3.times { survivor.increment!(:infection_reports) } # Assuming threshold is 3
      expect(survivor.reload.is_infected).to be true
    end
  end
end
