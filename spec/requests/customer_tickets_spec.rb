require 'rails_helper'

RSpec.describe 'Customer/Tickets' do
  before do
    @admin_auth_token = create(:admin).create_new_auth_token

    @agent = create(:agent, :confirmed)
    @agent_auth_token = @agent.create_new_auth_token

    @customer = create(:customer, :confirmed)
    @customer_id = @customer.to_param
    @customer_auth_token = @customer.create_new_auth_token

    @ticket = create(:ticket, customer_id: @customer_id)
    @ticket_id = @ticket.to_param

    @other_customer = create(:customer, :confirmed)
    @other_customer_id = @other_customer.to_param
    @other_customer_auth_token = @other_customer.create_new_auth_token
  end

  let(:valid_attributes) { attributes_for :ticket, customer_id: @customer_id }
  let(:invalid_attributes) { attributes_for :ticket, customer_id: @customer_id, description: nil }

  describe 'GET /api/v1/customers/:customer_id/tickets' do
    context 'when current user is an admin' do
      before { get "/api/v1/customers/#{@customer_id}/tickets", headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'when the current user is a customer' do
      context 'and the current customer is the requested customer' do
        before { get "/api/v1/customers/#{@customer_id}/tickets", headers: @customer_auth_token }
        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to match_response_schema 'ticket' }
      end

      context 'and the current customer is not the requested customer' do
        before { get "/api/v1/customers/#{@customer_id}/tickets", headers: @other_customer_auth_token }
        subject { response }

        it { is_expected.to have_http_status :unauthorized }
      end
    end

    context 'when a status is given' do
      before do
        get "/api/v1/customers/#{@customer_id}/tickets", params: { status: 0 }, headers: @customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end
  end

  describe 'POST /api/v1/customers/:customer_id/tickets' do
    context 'when current user is an agent' do
      before do
        post "/api/v1/customers/#{@customer_id}/tickets", params: {
          data: {
            type: 'tickets',
            attributes: valid_attributes
          }
        }, headers: @agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end

    context 'when current user is a customer other than the requested customer' do
      before do
        post "/api/v1/customers/#{@customer_id}/tickets", params: {
          data: {
            type: 'tickets',
            attributes: valid_attributes
          }
        }, headers: @other_customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end

    context 'with valid params' do
      before do
        post "/api/v1/customers/#{@customer_id}/tickets", params: {
          data: {
            type: 'tickets',
            attributes: valid_attributes
          }
        }, headers: @customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :created }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'with invalid params' do
      before do
        post "/api/v1/customers/#{@customer_id}/tickets", params: {
          data: {
            type: 'tickets',
            attributes: invalid_attributes
          }
        }, headers: @customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe 'GET /api/v1/customers/:customer_id/tickets/:id' do
    context 'when current user is an admin' do
      before { get "/api/v1/customers/#{@customer_id}/tickets/#{@ticket_id}", headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'when current user is a customer other than the requested customer' do
      before { get "/api/v1/customers/#{@customer.to_param}", headers: @current_auth_token }
      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end

    before { get "/api/v1/customers/#{@customer_id}/tickets/#{@ticket_id}", headers: @customer_auth_token }
    subject { response }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to match_response_schema 'ticket' }
  end

  describe 'PUT /api/v1/customers/:customer_id/tickets/:id' do
    context 'when current user is a customer other than the requested customer' do
      before do
        put "/api/v1/customers/#{@customer_id}/tickets/#{@ticket_id}", params: {
          data: {
            type: 'tickets',
            attributes: valid_attributes
          }
        }, headers: @other_customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end

    context 'with valid params' do
      before do
        put "/api/v1/customers/#{@customer_id}/tickets/#{@ticket_id}", params: {
          data: {
            type: 'tickets',
            attributes: valid_attributes
          }
        }, headers: @customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'ticket' }
    end

    context 'with invalid params' do
      let(:new_attributes) { attributes_for :customer }
      before do
        put "/api/v1/customers/#{@customer_id}/tickets/#{@ticket_id}", params: {
          data: {
            type: 'tickets',
            attributes: invalid_attributes
          }
        }, headers: @customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe 'DELETE /api/v1/customers/:customer_id/tickets/:id' do
    context 'when current user is an agent' do
      before { delete "/api/v1/customers/#{@customer_id}/tickets/#{@ticket_id}", headers: @agent_auth_token }
      subject { response }
      it { is_expected.to have_http_status :unauthorized }
    end

    context 'when current user is a customer other than the requested customer' do
      before { @id = create(:ticket, customer_id: @customer_id).to_param }
      before { delete "/api/v1/customers/#{@customer_id}/tickets/#{@id}", headers: @other_customer_auth_token }
      subject { response }
      it { is_expected.to have_http_status :unauthorized }
    end

    before { @id = create(:ticket, customer_id: @customer_id).to_param }
    it 'destroys the requested ticket' do
      expect do
        delete "/api/v1/customers/#{@customer_id}/tickets/#{@id}", headers: @admin_auth_token
      end.to change(Ticket, :count).by(-1)
    end

    before { delete "/api/v1/customers/#{@customer_id}/tickets/#{@ticket_id}", headers: @customer_auth_token }
    subject { response }
    it { is_expected.to have_http_status :no_content }
  end
end
