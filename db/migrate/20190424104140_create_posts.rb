class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :content
      t.string :comment
      t.date :start_time 
      t.date :end_time

      t.timestamps
    end
  end
end
