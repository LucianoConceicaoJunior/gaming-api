# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :password_digest
      t.references :organization, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
