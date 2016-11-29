require 'rails_helper'

RSpec.describe Agent do
  describe 'validations' do
    subject { build :agent }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many :tickets }
    it { is_expected.to have_many(:customers).through :tickets }
  end
end
