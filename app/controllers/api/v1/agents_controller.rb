module Api
  module V1
    class AgentsController < ApplicationController
      before_action :set_agent, only: [:show, :update, :destroy]
      devise_token_auth_group :member, contains: [:agent, :admin]
      before_action :authenticate_member!, only: [:show, :update, :destroy]
      before_action :deny_agent!, only: [:index, :create, :destroy]
      before_action :validate_agent!, only: [:show, :update]

      def index
        @agents = Agent.all

        render json: @agents
      end

      def show
        render json: @agent
      end

      def create
        @agent = Agent.new(agent_attributes)
        if @agent.save
          render json: @agent, status: :created
        else
          render json: @agent.errors, status: :unprocessable_entity
        end
      end

      def update
        if @agent.update(agent_attributes)
          render json: @agent
        else
          render json: @agent.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @agent.destroy
      end

      private

      def set_agent
        @agent = Agent.find(params[:id])
      end

      def agent_params
        params.require(:data).permit(:type, attributes: [:name, :email, :password, :password_confirmation])
      end

      def agent_attributes
        agent_params[:attributes] || {}
      end

      def deny_agent!
        render 'Access Denied!', status: :unauthorized unless current_member_is_admin?
      end

      def validate_agent!
        return if current_member_is_admin?

        render 'Access Denied!', status: :unauthorized unless current_member == @agent
      end

      def current_member_is_admin?
        current_member.is_a? Admin
      end
    end
  end
end
