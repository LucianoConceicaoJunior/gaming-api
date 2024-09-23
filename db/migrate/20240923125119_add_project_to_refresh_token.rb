# frozen_string_literal: true

class AddProjectToRefreshToken < ActiveRecord::Migration[7.2]
  def change
    add_reference :refresh_tokens, :project, null: true, foreign_key: true, type: :uuid
  end
end
