module Refinery
  module Locations
    class Location < Refinery::Core::BaseModel
      extend FriendlyId
      self.table_name = 'refinery_locations'

      attr_accessible :name, :image_id, :address, :address_2, :city, :state,
        :zip, :phone, :description, :map_code, :directions_code, :position, :hidden

      friendly_id :name, :use => [:slugged]
      acts_as_indexed :fields => [
        :name, :address, :address_2, :city, :state, :zip, :phone, :description
      ]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :image, :class_name => '::Refinery::Image'

      # meta
      def title; name; end

      def city_state_zip
        "#{city}, #{state} #{zip}"
      end

      # returns phone number with all punctuation removed and "+1" prepended
      def international_phone
        phone.gsub(/[^\d]/, "").prepend('+1')
      end

      # returns phone number with all extra punctuation from the CMS
      def formatted_phone
        phone
      end

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

      # Returns the previous url prior to any attribute assignments
      def url_was
        "#{self.class.url}/#{slug_was}"
      end

      def page
        @page ||= ::Refinery::Page.where(:link_url => url).first
      end

      def reload
        @page = nil
        super
      end

      after_create :create_page
      after_destroy :destroy_page

      before_update :remember_page
      after_update :update_page

    private

      def create_page
        self.class.transaction do
          if parent = self.class.page
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

      def remember_page
        @previous_page = ::Refinery::Page.where(:link_url => url_was).first
        @page = nil
      end

      def update_page
        if @previous_page
          @previous_page.update_attributes(
            :title => name,
            :link_url => url,
            :menu_match => "^#{url}(\/|\/.+?|)$"
          )
        end
      end

    end
  end
end
