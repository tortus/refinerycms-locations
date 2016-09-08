module Refinery
  module Locations
    module Admin
      class LocationsController < ::Refinery::AdminController

        crudify :'refinery/locations/location',
                :title_attribute => 'name', :xhr_paging => true




        private

        def location_params
          params.require(:location).permit(:name, :image_id, :address, :address_2, :city, :state,
                                       :zip, :phone, :description, :map_code, :directions_code, :position, :hidden)
        end

      end
    end
  end
end
