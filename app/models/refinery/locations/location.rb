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
      
      def self.url
        "/locations"
      end
      def self.page
        ::Refinery::Page.where(:link_url => url).first
      end
      
      def url
        "#{self.class.url}/#{friendly_id}"
      end
      def page
        @page ||= ::Refinery::Page.where(:link_url => url).first
      end
      
      after_create :create_page
      after_destroy :destroy_page

      def create_page
        if parent = self.class.page
          self.class.transaction do
            page = parent.children.create!(
              :title => name,
              :link_url => url,
              :deletable => false,
              :menu_match => "^#{url}(\/|\/.+?|)$"
            )
          end
        end
      end
      
      def destroy_page
        page.destroy! if page
      end

    end
  end
end
