# frozen_string_literal: true

class Api::Management::ProjectsController < ApplicationController
  def index
    @projects = Project.where(organization: @organization)
    render status: :ok, json: @projects, only: [ :id, :name ]
  end
end
