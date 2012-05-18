class CreateLocationsLocations < ActiveRecord::Migration

  def up
    create_table :refinery_locations do |t|
      t.integer :image_id
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.text :description
      t.text :map_code
      t.text :directions_code
      t.boolean :hidden, :default => false, :null => false
      t.string :slug
      t.integer :position

      t.timestamps
    end
    add_index :refinery_locations, :slug, :unique => true
  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-locations"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/locations/locations"})
    end

    remove_index :refinery_locations, :slug
    drop_table :refinery_locations

  end

end
