# frozen_string_literal: true

module Api
  module Management
    class OrganizationsController < ApplicationController
      before_action :authenticate
      def show
        render status: 200, json: @organization, only: [ :id, :name ]
      end
    end
  end
end
