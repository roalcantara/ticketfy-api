require 'rails_helper'

RSpec.describe Api::V1::TicketsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/customers/1/tickets').to route_to 'api/v1/tickets#index', format: :json, customer_id: '1'
    end

    it 'routes to #show' do
      expect(get: '/api/v1/customers/1/tickets/1')
        .to route_to 'api/v1/tickets#show', format: :json, customer_id: '1', id: '1'
    end

    it 'routes to #create' do
      expect(post: '/api/v1/customers/1/tickets')
        .to route_to 'api/v1/tickets#create', format: :json, customer_id: '1'
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/customers/1/tickets/1')
        .to route_to 'api/v1/tickets#update', format: :json, customer_id: '1', id: '1'
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/customers/1/tickets/1')
        .to route_to 'api/v1/tickets#update', format: :json, customer_id: '1', id: '1'
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/customers/1/tickets/1')
        .to route_to 'api/v1/tickets#destroy', format: :json, customer_id: '1', id: '1'
    end
  end
end
