class CreateMovies < ActiveRecord::Migration
  def self.up
	create_table :movie_ranks do |mr|
		mr.string :description
		mr.text :category
		mr.text :movienames
		mr.text :rank
		mr.timestamps
	end
  end

  def self.down
	drop_table :movie_ranks
  end

end
