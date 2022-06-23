class AddMissingNullChecks < ActiveRecord::Migration[6.1]
  def change # 88
    change_column_null :questions, :title, false
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
  end
end
