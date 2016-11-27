require 'rails_helper'

RSpec.describe 'Agents' do
  before do
    @admin_auth_token = create(:admin).create_new_auth_token

    @current_agent = create(:agent, :confirmed)
    @current_agent_auth_token = @current_agent.create_new_auth_token

    @agent = create(:agent, :confirmed)
    @agent_auth_token = @agent.create_new_auth_token
  end

  let(:valid_attributes) { attributes_for :agent }
  let(:invalid_attributes) { attributes_for :agent, name: nil }

  describe 'GET /api/v1/agents' do
    context 'when current user is an admin' do
      before { get '/api/v1/agents', headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
    end

    context 'when current user is not an admin' do
      before { get '/api/v1/agents', headers: @current_agent_auth_token }
      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end
  end

  describe 'POST /api/v1/agents' do
    context 'when current user is an admin' do
      context 'with valid params' do
        before do
          post '/api/v1/agents', params: {
            data: {
              type: 'agents',
              attributes: valid_attributes
            }
          }, headers: @admin_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :created }
      end

      context 'with invalid params' do
        before do
          post '/api/v1/agents', params: {
            data: {
              type: 'agents',
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
        post '/api/v1/agents', params: {
          data: {
            type: 'agents',
            attributes: valid_attributes
          }
        }, headers: @current_agent_auth_token
      end

      subject { response }

      it { is_expected.to have_http_status :unauthorized }
    end
  end

  describe 'GET /api/v1/agents/:id' do
    context 'when current user is an admin' do
      before { get "/api/v1/agents/#{@agent.to_param}", headers: @admin_auth_token }
      subject { response }

      it { is_expected.to have_http_status :ok }
    end

    context 'when the current user is an agent' do
      context 'and the current agent is the requested agent' do
        before { get "/api/v1/agents/#{@agent.to_param}", headers: @agent_auth_token }
        subject { response }

        it { is_expected.to have_http_status :ok }
      end

      context 'and the current agent is not the requested agent' do
        before { get "/api/v1/agents/#{@agent.to_param}", headers: @current_auth_token }
        subject { response }

        it { is_expected.to have_http_status :unauthorized }
      end
    end
  end

  describe 'PUT /api/v1/agents/:id' do
    context 'when current user is an admin' do
      context 'with valid params' do
        before do
          put "/api/v1/agents/#{@agent.to_param}", params: {
            data: {
              type: 'agents',
              attributes: valid_attributes
            }
          }, headers: @admin_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :ok }
      end

      context 'with invalid params' do
        let(:new_attributes) { attributes_for :agent }
        before do
          put "/api/v1/agents/#{@agent.to_param}", params: {
            data: {
              type: 'agents',
              attributes: invalid_attributes
            }
          }, headers: @admin_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :unprocessable_entity }
      end
    end

    context 'when the current user is an agent' do
      context 'and the current agent is the requested agent' do
        context 'with valid params' do
          before do
            put "/api/v1/agents/#{@agent.to_param}", params: {
              data: {
                type: 'agents',
                attributes: valid_attributes
              }
            }, headers: @agent_auth_token
          end

          subject { response }

          it { is_expected.to have_http_status :ok }
        end

        context 'with invalid params' do
          let(:new_attributes) { attributes_for :agent }
          before do
            put "/api/v1/agents/#{@agent.to_param}", params: {
              data: {
                type: 'agents',
                attributes: invalid_attributes
              }
            }, headers: @agent_auth_token
          end

          subject { response }

          it { is_expected.to have_http_status :unprocessable_entity }
        end
      end

      context 'and the current agent is not the requested agent' do
        before do
          put "/api/v1/agents/#{@agent.to_param}", params: {
            data: {
              type: 'agents',
              attributes: valid_attributes
            }
          }, headers: @current_agent_auth_token
        end

        subject { response }

        it { is_expected.to have_http_status :unauthorized }
      end
    end
  end

  describe 'DELETE /api/v1/agents/:id' do
    context 'when current user is an admin' do
      before { @id = create(:agent, :confirmed).to_param }
      it 'destroys the requested agent' do
        expect do
          delete "/api/v1/agents/#{@id}", headers: @admin_auth_token
        end.to change(Agent, :count).by(-1)
      end

      before { delete "/api/v1/agents/#{@agent.to_param}", headers: @admin_auth_token }
      subject { response }
      it { is_expected.to have_http_status :no_content }
    end

    context 'when current user is not an admin' do
      before { delete "/api/v1/agents/#{@agent.to_param}", headers: @agent_auth_token }
      subject { response }
      it { is_expected.to have_http_status :unauthorized }
    end
  end
end
