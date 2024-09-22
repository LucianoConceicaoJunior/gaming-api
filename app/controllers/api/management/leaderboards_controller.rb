# frozen_string_literal: true

class Api::Management::LeaderboardsController < ApplicationController
  def index
    project = @organization.projects.find_by(id: params[:project_id])
    leaderboards = Leaderboard.where(project:)
    render status: :ok, json: leaderboards, only: [ :id, :name, :period_type, :sort_type, :row_type ]
  end
end
