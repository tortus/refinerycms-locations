module Refinery
  module Locations
    class Location < Refinery::Core::BaseModel
      extend FriendlyId
      self.table_name = 'refinery_locations'

      attr_accessible :name, :image, :street, :city, :state, :zip, :phone, :description, :map_code, :directions_code, :position

      friendly_id :name, :use => [:slugged]
      acts_as_indexed :fields => [:name, :street, :city, :state, :zip, :phone, :description]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :image, :class_name => '::Refinery::Image'
    end
  end
end
