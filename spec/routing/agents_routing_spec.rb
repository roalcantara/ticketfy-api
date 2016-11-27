require 'rails_helper'

RSpec.describe Api::V1::AgentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/agents').to route_to 'api/v1/agents#index', format: :json
    end

    it 'routes to #show' do
      expect(get: '/api/v1/agents/1').to route_to 'api/v1/agents#show', format: :json, id: '1'
    end

    it 'routes to #create' do
      expect(post: '/api/v1/agents').to route_to 'api/v1/agents#create', format: :json
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/agents/1').to route_to 'api/v1/agents#update', format: :json, id: '1'
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/agents/1').to route_to 'api/v1/agents#update', format: :json, id: '1'
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/agents/1').to route_to 'api/v1/agents#destroy', format: :json, id: '1'
    end
  end
end
