class CreateLocations < ActiveRecord::Migration
  def change
    
    create_table :locations do |t|
      t.string :name
      t.string :url
      t.text :cached_results
      t.text :cached_source
      t.timestamps
    end

    create_table :locations_technologies, id: false do |t|
      t.integer :location_id
      t.integer :technology_id
    end

  end
end
