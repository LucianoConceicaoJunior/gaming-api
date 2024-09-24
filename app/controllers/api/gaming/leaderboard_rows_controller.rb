# frozen_string_literal: true

class Api::Gaming::LeaderboardRowsController < ApplicationController
  before_action :check_request
  def create
    leaderboard_row =  upsert_leaderboard_row
    if leaderboard_row
      render_response(options: { status: :ok, json: leaderboard_row.reload, only: [ :score, :user_id ] })
    else
      render_response(options: { status: :bad_request, json: { message: Api::Constants::Messages::COULD_NOT_CREATE_RECORD } })
    end
  end

  def get_leaderboard_rank
    leaderboard_rows = LeaderboardRow.select(select_statement).where(leaderboard_row_filter).joins(:user).order(score: leaderboard.sort_type.match(Leaderboard::SORT_REGEX).to_s.to_sym).limit(max_rows)
    render_response(options: { status: :ok, json: add_rank_to_response(leaderboard_rows:), except: [ 'id' ] })
  end

  def get_user_rank
    if params[:all_entries].to_s.downcase == 'true'
      leaderboard_rows = LeaderboardRow.select(select_statement).where(leaderboard_row_filter(user: true)).joins(:user).order(score: leaderboard.sort_type.match(Leaderboard::SORT_REGEX).to_s.to_sym)
    else
      leaderboard_rows = LeaderboardRow.select(select_statement).where(leaderboard_row_filter(user: true)).joins(:user).order(score: leaderboard.sort_type.match(Leaderboard::SORT_REGEX).to_s.to_sym).limit(1)
    end
    render_response(options: { status: :ok, json: leaderboard_rows, except: [ :id ] })
  end

  private

  def render_response(options: {})
    render options
  end
  def check_request
    result = check_parameters
    return render_response(options: result[:to_render]) unless result[:success]
    result = check_objects
    return render_response(options: result[:to_render]) unless result[:success]
    result = check_fields
    render_response(options: result[:to_render]) unless result[:success]
  end

  def check_parameters
    unless expected_params.all? { |p| params[p].present? }
      return { success: false, to_render: { response_code: :bad_request, json: { message: "#{Api::Constants::Messages::MISSING_PARAMETERS}: #{expected_params.select { |p| params[p].blank? }.join(',')}" } } }
    end
    { success: true }
  end

  def check_fields
    fields_to_check.each do |field|
      result = valid_field?(key: :score, value: score, kind: 'Integer')
      return { success: false, to_render: { response_code: :bad_request, json: result.last } } unless result.first
    end
    { success: true }
  end

  def fields_to_check
    case params[:action]
    when 'create'
      [ { key: :score, value: score, kind: 'Integer' } ]
    else
      []
    end
  end

  def check_objects
    objects_to_check.each do |key, value|
      return { success: false, to_render: { response_code: :bad_request, json: { message: "#{key.to_s.titleize} #{Api::Constants::Messages::RECORD_NOT_FOUND}" } } } unless value
    end
    { success: true }
  end

  def objects_to_check
    case params[:action]
    when 'create', 'get_leaderboard_rank', 'get_user_rank'
      { project:, leaderboard: }
    else
      []
    end
  end

  def valid_field?(key:, value:, kind:)
    return [ false, { message: "#{key.to_s.titleize} must be #{kind}" } ] unless value.is_a? kind.constantize
    case kind
    when 'Integer'
      return [ false, { message: "#{key.to_s.titleize} #{Api::Constants::Messages::GREATER_THAN_ZERO}" } ] unless value > 0
    else
      return [ false, json: { message: Api::Constants::Messages::UNKNOWN_FIELD_TYPE } ]
    end
    [ true, nil ]
  end

  def expected_params
    case params[:action]
    when 'create'
      %i[project_id leaderboard_id score]
    when 'get_leaderboard_rank', 'get_user_rank'
      %i[project_id leaderboard_id]
    else
      []
    end
  end

  def project
    @project ||= Project.find_by(id: params[:project_id])
  end

  def leaderboard
    @leaderboard ||= project&.leaderboards&.find_by(id: params[:leaderboard_id])
  end

  def current_time
    @current_time ||= Time.now.utc
  end

  def leaderboard_row_filter(user: false)
    filter = { leaderboard: }
    filter[:user] = current_user if user
    case leaderboard.period_type.to_sym
    when :daily
      filter.merge!({ day: current_time.day, month: current_time.month, year: current_time.year })
    when :weekly
      filter.merge!({ week: current_time.to_date.cweek, year: current_time.year })
    when :monthly
      filter.merge!({ month: current_time.month, year: current_time.year })
    when :yearly
      filter.merge!({ year: current_time.year })
    else
      filter
    end
  end

  def leaderboard_row
    @leaderboard_row ||= if leaderboard.all_entries?
                           LeaderboardRow.new
    else
                           LeaderboardRow.where(leaderboard_row_filter(user: true)).first_or_initialize
    end
  end

  def add_rank_to_response(leaderboard_rows:)
    leaderboard_rows.as_json.each_with_index { |r, index| r['rank'] = index + 1 }
  end

  def max_rows
    100
  end

  def select_statement
    'user_id, score, users.name AS user_name'
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
