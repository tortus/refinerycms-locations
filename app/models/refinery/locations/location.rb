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
      def title
        name
      end
      def meta_description
        page.meta_description if page
      end
      def meta_keywords
        page.meta_keywords if page
      end

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

      scope :active,      lambda { where(:hidden => false) }
      scope :live,        lambda { active }
      scope :by_position, lambda { order("position ASC") }
      scope :by_name,     lambda { order("name ASC") }

      def self.url
        "/locations"
      end
      def self.page
        ::Refinery::Page.where(:link_url => url).first
      end

      def url
        "#{self.class.url}/#{friendly_id}"
      end

      # Returns url of location prior to any attribute changes
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

      before_create :create_page
      before_destroy :destroy_page

      before_update :update_page

    private

      def create_page
        if parent = self.class.page
          @page = parent.children.create!(
            :title => name,
            :link_url => url,
            :deletable => false,
            :menu_match => "^#{url}(\/|\/.+?|)$"
          )
        end
      end

      def destroy_page
        page.destroy! if page
      end

      def update_page
        if @page ||= ::Refinery::Page.where(:link_url => url_was).first
          @page.update_attributes(
            :title => name,
            :link_url => url,
            :menu_match => "^#{url}(\/|\/.+?|)$"
          )
        end
      end

    end
  end
end
