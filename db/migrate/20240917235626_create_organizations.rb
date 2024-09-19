# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name, null: false
      t.string :api_key, null: false

      t.timestamps
    end
  end
end
