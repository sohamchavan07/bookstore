# frozen_string_literal: true

class CreateJobLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :job_logs do |t|
      t.string :job_name
      t.string :status
      t.datetime :executed_at
      t.text :message

      t.timestamps
    end
  end
end
