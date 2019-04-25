class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :content,  default: "未定"
      t.date :start_time 

      t.timestamps
    end
  end
end
