# frozen_string_literal: true

class CreateLeaderboards < ActiveRecord::Migration[7.2]
  def change
    create_table :leaderboards, id: :uuid do |t|
      t.string :name, null: false
      t.integer :period_type, null: false, default: 0
      t.integer :sort_type, null: false, default: 0
      t.integer :row_type, null: false, default: 0
      t.references :project, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
