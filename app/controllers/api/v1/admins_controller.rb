module Api
  module V1
    class AdminsController < ApplicationController
      before_action :set_admin, only: [:show, :update, :destroy]
      before_action :authenticate_admin!

      def index
        @admins = Admin.all

        render json: @admins
      end

      def show
        render json: @admin
      end

      def create
        @admin = Admin.new(admin_attributes)
        if @admin.save
          render json: @admin, status: :created
        else
          render json: @admin.errors, status: :unprocessable_entity
        end
      end

      def update
        if @admin.update(admin_attributes)
          render json: @admin
        else
          render json: @admin.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @admin.destroy
      end

      private

      def set_admin
        @admin = Admin.find(params[:id])
      end

      def admin_params
        params.require(:data).permit(:type, attributes: [:name, :email, :password, :password_confirmation])
      end

      def admin_attributes
        admin_params[:attributes] || {}
      end
    end
  end
end
