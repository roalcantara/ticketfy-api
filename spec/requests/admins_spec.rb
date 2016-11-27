require 'rails_helper'

RSpec.describe 'Admins' do
  before do
    @current_user = create(:admin)
    @auth_token = @current_user.create_new_auth_token
  end
  let(:valid_attributes) { attributes_for :admin }
  let(:invalid_attributes) { attributes_for :admin, name: nil }
  let(:admin) { create :admin }

  describe 'GET /api/v1/admins' do
    before { get '/api/v1/admins', headers: @auth_token }
    subject { response }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to match_response_schema 'admin' }
  end

  describe 'POST /api/v1/admins' do
    context 'with valid params' do
      before do
        post '/api/v1/admins', params: {
          data: {
            type: 'admins',
            attributes: valid_attributes
          }
        }, headers: @auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :created }
      it { is_expected.to match_response_schema 'admin' }
    end

    context 'with invalid params' do
      before do
        post '/api/v1/admins', params: {
          data: {
            type: 'admins',
            attributes: invalid_attributes
          }
        }, headers: @auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe 'GET /api/v1/admins/:id' do
    before { get "/api/v1/admins/#{admin.to_param}", headers: @auth_token }
    subject { response }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to match_response_schema 'admin' }
  end

  describe 'PUT /api/v1/admins/:id' do
    context 'with valid params' do
      before do
        put "/api/v1/admins/#{admin.to_param}", params: {
          data: {
            type: 'admins',
            attributes: valid_attributes
          }
        }, headers: @auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'admin' }
    end

    context 'with invalid params' do
      let(:new_attributes) { attributes_for :admin }
      before do
        put "/api/v1/admins/#{admin.to_param}", params: {
          data: {
            type: 'admins',
            attributes: invalid_attributes
          }
        }, headers: @auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe 'DELETE /api/v1/admins/:id' do
    before { @id = create(:admin).id }
    it 'destroys the requested admin' do
      expect do
        delete "/api/v1/admins/#{@id}", headers: @auth_token
      end.to change(Admin, :count).by(-1)
    end

    before { delete "/api/v1/admins/#{admin.to_param}", headers: @auth_token }
    subject { response }
    it { is_expected.to have_http_status :no_content }
  end
end
