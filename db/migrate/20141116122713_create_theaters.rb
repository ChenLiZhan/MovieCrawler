class CreateTheaters < ActiveRecord::Migration
  def self.up
    create_table :theaters do |t|
      t.string :type
      t.string :category
      t.text :content
    end
  end

  def self.down
    drop_table :theaters
  end
end
