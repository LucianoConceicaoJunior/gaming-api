# frozen_string_literal: true

class CreateLeaderboardRows < ActiveRecord::Migration[7.2]
  def change
    create_table :leaderboard_rows, id: :uuid do |t|
      t.integer :score, null: false
      t.integer :day, null: false
      t.integer :week, null: false
      t.integer :month, null: false
      t.integer :year, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
