# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true } # 78 стр
      t.string :name
      t.string :password_digest

      t.timestamps
    end
  end
end
