# frozen_string_literal: true

class CreateWhitelistedTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :whitelisted_tokens, id: :uuid do |t|
      t.string :jti
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.datetime :exp

      t.timestamps
    end
    add_index :whitelisted_tokens, :jti, unique: true
  end
end
