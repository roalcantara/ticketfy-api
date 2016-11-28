require 'rails_helper'

RSpec.describe 'Customers' do
  before do
    @admin_auth_token = create(:admin).create_new_auth_token

    @current_customer = create(:customer, :confirmed)
    @current_customer_auth_token = @current_customer.create_new_auth_token

    @customer = create(:customer, :confirmed)
    @customer_auth_token = @customer.create_new_auth_token
  end

  let(:valid_attributes) { attributes_for :customer }
  let(:invalid_attributes) { attributes_for :customer, name: nil }

  describe 'GET /api/v1/customers' do
    context 'when current user is an admin' do
      before { get '/api/v1/customers', headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'customer' }
    end

    context 'when current user is not an admin' do
      before { get '/api/v1/customers', headers: @current_customer_auth_token }
      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end
  end

  describe 'POST /api/v1/customers' do
    context 'when current user is an admin' do
      context 'with valid params' do
        before do
          post '/api/v1/customers', params: {
            data: {
              type: 'customers',
              attributes: valid_attributes
            }
          }, headers: @admin_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :created }
        it { is_expected.to match_response_schema 'customer' }
      end

      context 'with invalid params' do
        before do
          post '/api/v1/customers', params: {
            data: {
              type: 'customers',
              attributes: invalid_attributes
            }
          }, headers: @admin_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :unprocessable_entity }
      end
    end

    context 'when current user is not an admin' do
      before do
        post '/api/v1/customers', params: {
          data: {
            type: 'customers',
            attributes: valid_attributes
          }
        }, headers: @current_customer_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end
  end

  describe 'GET /api/v1/customers/:id' do
    context 'when current user is an admin' do
      before { get "/api/v1/customers/#{@customer.to_param}", headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to match_response_schema 'customer' }
    end

    context 'when the current user is an customer' do
      context 'and the current customer is the requested customer' do
        before { get "/api/v1/customers/#{@customer.to_param}", headers: @customer_auth_token }
        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to match_response_schema 'customer' }
      end

      context 'and the current customer is not the requested customer' do
        before { get "/api/v1/customers/#{@customer.to_param}", headers: @current_auth_token }
        subject { response }

        it { is_expected.to have_http_status :unauthorized }
      end
    end
  end

  describe 'PUT /api/v1/customers/:id' do
    context 'when current user is an admin' do
      context 'with valid params' do
        before do
          put "/api/v1/customers/#{@customer.to_param}", params: {
            data: {
              type: 'customers',
              attributes: valid_attributes
            }
          }, headers: @admin_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to match_response_schema 'customer' }
      end

      context 'with invalid params' do
        let(:new_attributes) { attributes_for :customer }
        before do
          put "/api/v1/customers/#{@customer.to_param}", params: {
            data: {
              type: 'customers',
              attributes: invalid_attributes
            }
          }, headers: @admin_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :unprocessable_entity }
      end
    end

    context 'when the current user is an customer' do
      context 'and the current customer is the requested customer' do
        context 'with valid params' do
          before do
            put "/api/v1/customers/#{@customer.to_param}", params: {
              data: {
                type: 'customers',
                attributes: valid_attributes
              }
            }, headers: @customer_auth_token
          end

          subject { response }

          it { is_expected.to have_http_status :ok }
          it { is_expected.to match_response_schema 'customer' }
        end

        context 'with invalid params' do
          let(:new_attributes) { attributes_for :customer }
          before do
            put "/api/v1/customers/#{@customer.to_param}", params: {
              data: {
                type: 'customers',
                attributes: invalid_attributes
              }
            }, headers: @customer_auth_token
          end

          subject { response }

          it { is_expected.to have_http_status :unprocessable_entity }
        end
      end

      context 'and the current customer is not the requested customer' do
        before do
          put "/api/v1/customers/#{@customer.to_param}", params: {
            data: {
              type: 'customers',
              attributes: valid_attributes
            }
          }, headers: @current_customer_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :unauthorized }
      end
    end
  end

  describe 'DELETE /api/v1/customers/:id' do
    context 'when current user is an admin' do
      before { @id = create(:customer, :confirmed).to_param }
      it 'destroys the requested customer' do
        expect do
          delete "/api/v1/customers/#{@id}", headers: @admin_auth_token
        end.to change(Customer, :count).by(-1)
      end

      before { delete "/api/v1/customers/#{@customer.to_param}", headers: @admin_auth_token }
      subject { response }
      it { is_expected.to have_http_status :no_content }
    end

    context 'when current user is not an admin' do
      before { delete "/api/v1/customers/#{@customer.to_param}", headers: @customer_auth_token }
      subject { response }
      it { is_expected.to have_http_status :unauthorized }
    end
  end
end
