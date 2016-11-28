module Api
  module V1
    class CustomersController < ApplicationController
      before_action :set_customer, only: [:show, :update, :destroy]
      devise_token_auth_group :member, contains: [:customer, :admin]
      before_action :authenticate_member!, only: [:show, :update, :destroy]
      before_action :deny_customer!, only: [:index, :create, :destroy]
      before_action :validate_customer!, only: [:show, :update]

      def index
        @customers = Customer.all

        render json: @customers
      end

      def show
        render json: @customer
      end

      def create
        @customer = Customer.new(customer_attributes)

        if @customer.save
          render json: @customer, status: :created
        else
          render json: @customer.errors, status: :unprocessable_entity
        end
      end

      def update
        if @customer.update(customer_attributes)
          render json: @customer
        else
          render json: @customer.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @customer.destroy
      end

      private

      def set_customer
        @customer = Customer.find(params[:id])
      end

      def customer_params
        params.require(:data).permit(:type, attributes: [:name, :email, :password, :password_confirmation])
      end

      def customer_attributes
        customer_params[:attributes] || {}
      end

      def deny_customer!
        render 'Access Denied!', status: :unauthorized unless current_member_is_admin?
      end

      def validate_customer!
        return if current_member_is_admin?

        render 'Access Denied!', status: :unauthorized unless current_member == @customer
      end

      def current_member_is_admin?
        current_member.is_a? Admin
      end
    end
  end
end
