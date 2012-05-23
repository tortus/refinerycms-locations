class AddAddress2ToLocationsLocations < ActiveRecord::Migration

  def change
    add_column :refinery_locations, :address_2, :string
  end

end
