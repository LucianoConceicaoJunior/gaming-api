# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name, null: false
      t.references :organization, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
