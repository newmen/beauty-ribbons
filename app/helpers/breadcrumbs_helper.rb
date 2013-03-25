module BreadcrumbsHelper
  class WiseBuilder < BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder
    def render_element(element)
      if element.path == nil
        content = compute_name(element)
      else
        content = @context.link_to_unless_current(compute_name(element),
                                                  compute_path(element),
                                                  element.options.merge(data: { push: true }))
      end
      if @options[:tag]
        @context.content_tag(@options[:tag], content)
      else
        content
      end
    end

  end

  def render_wisebreadcrumbs
    render_breadcrumbs(builder: WiseBuilder)
  end
end