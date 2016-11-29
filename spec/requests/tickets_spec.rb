require 'rails_helper'

RSpec.describe 'Tickets' do
  before do
    @admin_auth_token = create(:admin).create_new_auth_token

    @agent = create(:agent, :confirmed)
    @agent_id = @agent.to_param
    @agent_auth_token = @agent.create_new_auth_token

    @customer = create(:customer, :confirmed)
    @customer_id = @customer.to_param
    @customer_auth_token = @customer.create_new_auth_token
  end

  let(:valid_attributes) { attributes_for :ticket, agent_id: @agent_id }
  let(:invalid_attributes) { attributes_for :ticket, agent_id: @agent_id, description: nil }

  describe 'GET /api/v1/tickets' do
    context 'when current agent is a customer' do
      before { get '/api/v1/tickets', headers: @customer_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
    end

    context 'when current user is an admin' do
      before { get '/api/v1/tickets', headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
    end

    context 'when current user is an agent' do
      before { get '/api/v1/tickets', headers: @agent_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
    end
  end
end
