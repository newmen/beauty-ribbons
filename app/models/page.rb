class Page < ActiveRecord::Base
  has_many :page_images, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :markdown, presence: true

  class << self
    def method_missing(method_name, *args, &block)
      if method_name =~ /\Afind_by_/
        super
      else
        page = where(identifier: method_name).first
        page || super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name =~ /\Afind_by_/ || where(identifier: method_name).exists? || super
    end
  end

  def html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(markdown.gsub("- ", "– "))
  end
end
