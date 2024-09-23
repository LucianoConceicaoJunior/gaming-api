# frozen_string_literal: true

class CreateBlacklistedTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :blacklisted_tokens, id: :uuid do |t|
      t.string :token, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.datetime :expire_at, null: false

      t.timestamps
    end
  end
end
