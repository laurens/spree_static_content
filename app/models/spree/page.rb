class Spree::Page < ActiveRecord::Base
  default_scope :order => "position ASC"

  validates_presence_of :title
  validates_presence_of [:slug, :body], :unless => :using_foreign_link?
  validates_presence_of :layout, :if => :render_layout_as_partial?

  scope :visible, where(:visible => true)
  scope :header_links, where(:show_in_header => true).visible
  scope :footer_links, where(:show_in_footer => true).visible
  scope :sidebar_links, where(:show_in_sidebar => true).visible

  before_save :update_positions_and_slug

  attr_accessible :title, :slug, :body, :meta_title, :meta_keywords, :meta_description, :layout, :foreign_link, :position, :show_in_sidebar, :show_in_header, :show_in_footer, :visible, :render_layout_as_partial

  def initialize(*args)
    super(*args)

    last_page = Spree::Page.last
    self.position = last_page ? last_page.position + 1 : 0
  end

  def link
    foreign_link.blank? ? slug : foreign_link
  end

  def self.find_by_slug(slug)
    slug = Spree::StaticPage.ensure_slug_prefix(slug)
    super(slug)
  end

  def self.find_by_slug!(slug)
    slug = Spree::StaticPage.ensure_slug_prefix(slug)
    super(slug)
  end

private

  def update_positions_and_slug
    self.slug = Spree::StaticPage.ensure_slug_prefix(self.slug) unless using_foreign_link?

    unless new_record?
      return unless prev_position = Spree::Page.find(self.id).position
      if prev_position > self.position
        Spree::Page.update_all("position = position + 1", ["? <= position AND position < ?", self.position, prev_position])
      elsif prev_position < self.position
        Spree::Page.update_all("position = position - 1", ["? < position AND position <= ?", prev_position,  self.position])
      end
    end

    true
  end

  def using_foreign_link?
    foreign_link.present?
  end
end
