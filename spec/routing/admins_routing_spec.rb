require 'rails_helper'

RSpec.describe Api::V1::AdminsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/admins').to route_to 'api/v1/admins#index', format: :json
    end

    it 'routes to #show' do
      expect(get: '/api/v1/admins/1').to route_to 'api/v1/admins#show', format: :json, id: '1'
    end

    it 'routes to #create' do
      expect(post: '/api/v1/admins').to route_to 'api/v1/admins#create', format: :json
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/admins/1').to route_to 'api/v1/admins#update', format: :json, id: '1'
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/admins/1').to route_to 'api/v1/admins#update', format: :json, id: '1'
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/admins/1').to route_to 'api/v1/admins#destroy', format: :json, id: '1'
    end
  end
end
