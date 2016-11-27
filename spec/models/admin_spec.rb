require 'rails_helper'

RSpec.describe Admin do
  describe 'validations' do
    subject { build :admin }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
