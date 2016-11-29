require 'rails_helper'

RSpec.describe 'Agent/Tickets' do
  before do
    @admin_auth_token = create(:admin).create_new_auth_token

    @agent = create(:agent, :confirmed)
    @agent_id = @agent.to_param
    @agent_auth_token = @agent.create_new_auth_token

    @ticket = create(:ticket, agent_id: @agent_id)
    @ticket_id = @ticket.to_param

    @other_agent = create(:agent, :confirmed)
    @other_agent_id = @other_agent.to_param
    @other_agent_auth_token = @other_agent.create_new_auth_token
  end

  let(:valid_attributes) { attributes_for :ticket, agent_id: @agent_id }
  let(:invalid_attributes) { attributes_for :ticket, agent_id: @agent_id, description: nil }

  describe 'GET /api/v1/agents/:agent_id/tickets' do
    context 'when current user is an admin' do
      before { get "/api/v1/agents/#{@agent_id}/tickets", headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'when the current user is an agent' do
      context 'and the current agent is the requested agent' do
        before { get "/api/v1/agents/#{@agent_id}/tickets", headers: @agent_auth_token }
        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to match_response_schema 'ticket' }
      end

      context 'and the current agent is not the requested agent' do
        before { get "/api/v1/agents/#{@agent_id}/tickets", headers: @other_agent_auth_token }
        subject { response }

        it { is_expected.to have_http_status :unauthorized }
      end
    end

    context 'when a status is given' do
      before do
        get "/api/v1/agents/#{@agent_id}/tickets", params: { status: 0 }, headers: @agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'when a updated_at from/to are given' do
      before do
        get "/api/v1/agents/#{@agent_id}/tickets", params: { from: '2016/12/01', to: '2016/12/30' }, headers: @agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :ok }
    end
  end

  describe 'PUT /api/v1/agents/:agent_id/tickets/:id/assign' do
    context 'to an unassigned ticket' do
      let(:new_ticket) { create :ticket, agent: nil }
      before do
        put "/api/v1/agents/#{@agent_id}/tickets/#{new_ticket.to_param}/assign", headers: @agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'to an already assigned ticket' do
      let(:existing_ticket) { create :ticket, agent: @other_agent }
      before do
        put "/api/v1/agents/#{@agent_id}/tickets/#{existing_ticket.to_param}/assign", headers: @agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe 'GET /api/v1/agents/:agent_id/tickets/:id' do
    context 'when current user is an admin' do
      before { get "/api/v1/agents/#{@agent_id}/tickets/#{@ticket_id}", headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
    end

    context 'when current user is an agent other than the requested agent' do
      before { get "/api/v1/agents/#{@agent.to_param}", headers: @other_agent_auth_token }
      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end

    before { get "/api/v1/agents/#{@agent_id}/tickets/#{@ticket_id}", headers: @agent_auth_token }
    subject { response }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to match_response_schema 'ticket' }
  end

  describe 'PUT /api/v1/agents/:agent_id/tickets/:id' do
    context 'when current user is a agent other than the requested agent' do
      before do
        put "/api/v1/agents/#{@agent_id}/tickets/#{@ticket_id}", params: {
          data: {
            type: 'tickets',
            attributes: valid_attributes
          }
        }, headers: @other_agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end

    context 'with valid params' do
      before do
        put "/api/v1/agents/#{@agent_id}/tickets/#{@ticket_id}", params: {
          data: {
            type: 'tickets',
            attributes: valid_attributes
          }
        }, headers: @agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'with invalid params' do
      let(:new_attributes) { attributes_for :agent }
      before do
        put "/api/v1/agents/#{@agent_id}/tickets/#{@ticket_id}", params: {
          data: {
            type: 'tickets',
            attributes: invalid_attributes
          }
        }, headers: @agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end
end
