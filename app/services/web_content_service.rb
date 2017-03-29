class WebContentService
  def initialize(link)
    @link = link
  end

  def content
    Sanitize.fragment(HTTParty.get(@link.url).body)
  end
end
