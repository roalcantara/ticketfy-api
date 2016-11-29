module Api
  module V1
    class TicketsController < ApplicationController
      before_action :set_customer
      before_action :set_agent
      before_action :deny_agent!, only: [:create, :destroy]
      before_action :set_ticket, only: [:show, :update, :destroy, :assign]
      devise_token_auth_group :member, contains: [:admin, :agent, :customer]
      before_action :authorize_customer!
      before_action :authorize_agent!

      def index
        @tickets = Ticket.by_updated_at(from: params[:from], to: params[:to])
                         .by_status(params[:status]&.to_sym)
                         .by_customer(@customer)
                         .by_agent(@agent)

        render json: @tickets
      end

      def show
        render json: @ticket
      end

      def create
        @ticket = Ticket.new(ticket_attributes)
        if @ticket.save
          render json: @ticket, status: :created
        else
          render json: @ticket.errors, status: :unprocessable_entity
        end
      end

      def update
        if @ticket.update(ticket_attributes)
          render json: @ticket
        else
          render json: @ticket.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @ticket.destroy
      end

      def assign
        if @ticket.assign!(@agent)
          render json: @ticket
        else
          render json: @ticket.errors, status: :unprocessable_entity
        end
      end

      private

      def set_customer
        @customer = find_customer
      end

      def find_customer
        return Customer.find(params[:customer_id]) if params.key?(:customer_id)
        current_member_is_customer? ? current_member : nil
      end

      def set_ticket
        @ticket = Ticket.find(params[:id])
      end

      def set_agent
        @agent = find_agent
      end

      def find_agent
        Agent.find(params[:agent_id]) if params.key?(:agent_id)
      end

      def ticket_params
        params.require(:data).permit(:type, attributes: [:status, :description, :customer_id, :agent_id])
      end

      def ticket_attributes
        ticket_params[:attributes] || {}
      end

      def authorize_customer!
        return unless current_member_is_customer?
        render 'Access Denied!', status: :unauthorized unless current_member == @customer
      end

      def authorize_agent!
        return unless current_member_is_agent?
        return if @agent.nil?
        render 'Access Denied!', status: :unauthorized unless current_member == @agent
      end

      def deny_agent!
        render 'Access Denied!', status: :unauthorized if current_member_is_agent?
      end

      def current_member_is_customer?
        current_member.is_a? Customer
      end

      def current_member_is_agent?
        current_member.is_a? Agent
      end
    end
  end
end
