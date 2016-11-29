require 'rails_helper'

RSpec.describe Ticket do
  describe 'validations' do
    it { is_expected.to validate_presence_of :status }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :customer }
    it { is_expected.to define_enum_for(:status).with [:pending, :in_progress, :closed] }

    context 'when status is :in_progress' do
      subject { build :ticket, status: :in_progress }

      it { is_expected.to validate_presence_of :agent }
    end

    context 'when status is :closed' do
      subject { build :ticket, status: :closed }

      it { is_expected.to validate_presence_of :agent }
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:customer).with_prefix true }
    it { is_expected.to delegate_method(:name).to(:agent).with_prefix true }
  end

  describe '#assign!' do
    let(:agent) { create :agent }

    context 'with an unassigned ticket' do
      let(:ticket) { create :ticket, agent: nil }

      it do
        expect { ticket.assign!(agent) }
          .to change { [ticket.reload.agent, ticket.reload.status] }
          .from([nil, 'pending']).to([agent, 'in_progress'])
      end
    end

    context 'with an assigned ticket' do
      let(:ticket) { create :ticket, :with_agent, status: :in_progress }

      subject { ticket.assign!(agent) }

      it { is_expected.to be_falsey }
    end
  end
end
