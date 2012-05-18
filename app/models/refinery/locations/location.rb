module Refinery
  module Locations
    class Location < Refinery::Core::BaseModel
      extend FriendlyId
      self.table_name = 'refinery_locations'

      attr_accessible :name, :image_id, :address, :city, :state, :zip,
      :phone, :description, :map_code, :directions_code, :position, :hidden

      friendly_id :name, :use => [:slugged]
      acts_as_indexed :fields => [:name, :address, :city, :state, :zip, :phone, :description]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :image, :class_name => '::Refinery::Image'
      
      def self.active; where(:hidden => false); end
      def self.live; active; end
      def self.by_position; order("position ASC"); end
      def self.by_name; order("name ASC"); end
    end
  end
end
