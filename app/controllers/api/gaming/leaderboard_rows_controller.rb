# frozen_string_literal: true

class Api::Gaming::LeaderboardRowsController < ApplicationController
  before_action :check_data
  def create
    leaderboard_row =  upsert_leaderboard_row
    if leaderboard_row
      render status: :ok, json: leaderboard_row.reload
    else
      render status: :bad_request, json: { message: Api::Constants::Messages::COULD_NOT_CREATE_RECORD }
    end
  end

  private
  def check_data
    unless expected_params.all? { |p| params[p].present? }
      return render status: :bad_request, json: { message: "#{Api::Constants::Messages::MISSING_PARAMETERS}: #{expected_params.select { |p| params[p].blank? }.join(',')}" }
    end
    return render status: :bad_request, json: { message: Api::Constants::Messages::PROJECT_NOT_FOUND } unless project
    render status: :bad_request, json: { message: Api::Constants::Messages::LEADERBOARD_NOT_FOUND } unless leaderboard
    result = valid_field?(key: :score, value: score, kind: 'Integer')
    unless result.first
      render status: :bad_request, json: result.last
    end
  end

  def valid_field?(key:, value:, kind:)
    return [ false, { message: "#{key} must be #{kind}" } ] unless value.is_a? kind.constantize
    case kind
    when 'Integer'
      return [ false, { message: "#{key} #{Api::Constants::Messages::GREATER_THAN_ZERO}" } ] unless value > 0
    else
      return [ false, json: { message: Api::Constants::Messages::UNKNOWN_FIELD_TYPE } ]
    end
    [ true, nil ]
  end

  def expected_params
    %i[project_id leaderboard_id score]
  end

  def project
    @project ||= Project.find(params[:project_id])
  end

  def leaderboard
    @leaderboard ||= project.leaderboards.find(params[:leaderboard_id])
  end

  def current_time
    @current_time ||= Time.now.utc
  end

  def leaderboard_row
    @leaderboard_row ||= if leaderboard.all_entries?
                           LeaderboardRow.new
    else
                           filters = { user: current_user, leaderboard: }
                           case leaderboard.period_type.to_sym
                           when :daily
                             filters.merge!({ day: current_time.day, month: current_time.month, year: current_time.year })
                           when :weekly
                             filters.merge!({ week: current_time.to_date.cweek, year: current_time.year })
                           when :monthly
                             filters.merge!({ month: current_time.month, year: current_time.year })
                           when :yearly
                             filters.merge!({ year: current_time.year })
                           else
                             filters
                           end
                           LeaderboardRow.where(filters).first_or_initialize
    end
  end

  def score
    @score ||= params[:score].to_i
  end

  def upsert_leaderboard_row
    new_score = (leaderboard_row.score || 0)
    case leaderboard.row_type.to_sym
    when :best
      if score > (leaderboard_row.score || 0)
        new_score = score
      end
    when :latest, :all_entries
      new_score = score
    when :accumulative
      new_score = score + (leaderboard_row.score || 0)
    end
    leaderboard_row.score = new_score
    leaderboard_row.day = current_time.day
    leaderboard_row.week = current_time.to_date.cweek
    leaderboard_row.month = current_time.month
    leaderboard_row.year = current_time.year
    leaderboard_row.user = current_user
    leaderboard_row.leaderboard = leaderboard
    if leaderboard_row.save
      leaderboard_row
    else
      nil
    end
  end
end
