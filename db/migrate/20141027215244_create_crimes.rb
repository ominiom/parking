class CreateCrimes < ActiveRecord::Migration
  def change
    create_table :crimes do |t|
      t.float :latitude
      t.float :longitude
      t.integer :year
      t.integer :month
      t.string :kind
    end
  end
end
