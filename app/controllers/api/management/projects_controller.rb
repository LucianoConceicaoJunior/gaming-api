# frozen_string_literal: true

class Api::Management::ProjectsController < ApplicationController
  def index
    @projects = Project.where(organization: @organization)
    render status: 200, json: @projects, only: [ :id, :name ]
  end
end
