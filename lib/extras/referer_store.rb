# @abstract Module for storing referer
# @author newmen<altermn@gmail.com>
# @date Dec 03, 2012
module RefererStore
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Sets the hook to save the referer excluding referer URLs parts passed
    #
    # @overload(uri_part)
    #   @param [String] uri_part that will be ignored
    # @overload(uri_part1, uri_part2, ...)
    #   @param [Array] uri_parts that will be ignored
    # @overload(..., before_filter_options)
    #   @param [Hash] before_filter_options Hash that contains options for before_filter
    #
    # @example Store referer if request not from *users* page and only for #show method
    #   store_referer :users, only: show
    def store_referer_except(*uris)
      before_filter_options = uris.extract_options!
      before_filter :store_back_url, before_filter_options

      except_regexp = uris.join('|')
      define_method(:store_back_url) do
        back_path =
          if request.referer && URI.parse(request.referer).host == URI.parse(root_url).host
            URI.parse(request.referer).path
          else
            root_path
          end

        unless session[:back_url] && back_path =~ /#{except_regexp}/
          session[:back_url] = URI.join(root_url, back_path).to_s
        end
      end
      private :store_back_url
    end

    # Sets the hook to save the referer
    def store_referer
      store_referer_except
    end
  end

  private

  def referer_url
    session[:back_url]
  end
end