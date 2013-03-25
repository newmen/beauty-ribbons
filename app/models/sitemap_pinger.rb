require 'net/http'

class SitemapPinger
  SEARCH_ENGINES = {
    google: "http://www.google.com/webmasters/tools/ping?sitemap=%s",
    bing: "http://www.bing.com/webmaster/ping.aspx?siteMap=%s",
    yandex: " http://webmaster.yandex.ru/addurl.xml?url=%s"
  }

  def self.ping(root_url)
    SitemapLogger.info Time.now
    SEARCH_ENGINES.each do |name, url|
      request = url % URI.join(root_url, 'sitemap.xml')
      SitemapLogger.info "  Pinging #{name} with #{request}"
      if Rails.env.production?
        begin
          response = Net::HTTP.get_response(URI.parse(request))
          SitemapLogger.info "    #{response.code}: #{response.message}"
          SitemapLogger.info "    Body: #{response.body}"
        rescue Exception => e
          SitemapLogger.info "    Error: #{e.message}"
        end
      end
    end
  end
end