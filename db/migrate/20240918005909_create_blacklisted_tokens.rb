# frozen_string_literal: true

class CreateBlacklistedTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :blacklisted_tokens, id: :uuid do |t|
      t.string :jti
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.datetime :exp

      t.timestamps
    end
    add_index :blacklisted_tokens, :jti, unique: true
  end
end
