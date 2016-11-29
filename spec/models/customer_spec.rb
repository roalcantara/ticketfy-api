require 'rails_helper'

RSpec.describe Customer do
  describe 'validations' do
    subject { build :customer }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many :tickets }
  end
end
