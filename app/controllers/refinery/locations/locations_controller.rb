module Refinery
  module Locations
    class LocationsController < ::ApplicationController

      before_filter :find_all_locations

      def index
        @page = Location.page
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @location in the line below:
        present(@page)
      end

      def show
        @location = Location.find(params[:id])
        @page = @location.page

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @location in the line below:
        present(@location)
      end

    protected

      def find_all_locations
        @locations = Location.active.by_position
      end

    end
  end
end
