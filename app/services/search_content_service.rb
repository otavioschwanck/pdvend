class SearchContentService
  def initialize(key_word)
    @key_word = key_word
  end

  def search
    found_links = []

    Link.all.each do |link|
      service = WebContentService.new(link)

      content = service.content

      unless scan_content_count(content).zero?
        found_links << {url: link.url, times: scan_content_count(content)}
      end
    end

    make_response(found_links)
  end

  private

  def scan_content_count(content)
    content.scan(/(?=#{@key_word})/i).count
  end

  def make_response(links)
    links.sort_by { |a| -a[:times] }.map{ |link| link[:url] }.to_json
  end
end
