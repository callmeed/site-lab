class AddCounterCacheToTechnologies < ActiveRecord::Migration
  def change
    add_column :technologies, :locations_count, :integer
  end
end
