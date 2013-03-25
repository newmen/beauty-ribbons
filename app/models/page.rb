# coding: utf-8

class Page < ActiveRecord::Base
  attr_accessible :title, :markdown, :page_image_ids

  has_many :page_images, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :markdown, presence: true

  class << self
    def method_missing(method_name, *args)
      if method_name =~ /\Afind_by_/
        super
      else
        page = where(identifier: method_name).first
        page || super
      end
    end
  end

  def html
    BlueCloth.new(markdown.gsub('- ', '– ')).to_html
  end
end
