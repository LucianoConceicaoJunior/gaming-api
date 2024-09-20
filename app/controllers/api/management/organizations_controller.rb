# frozen_string_literal: true

class Api::Management::OrganizationsController < ApplicationController
  def show
    render status: 200, json: @organization, only: [ :id, :name ]
  end
end
