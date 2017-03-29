class WebContentService
  def initialize(link)
    @link = link
  end

  def content
    byebug
    
    HTTParty.get(@link.url).body
  end
end
