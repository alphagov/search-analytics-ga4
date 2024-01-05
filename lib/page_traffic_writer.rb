class PageTrafficWriter
  def initialize(ranked_page_traffic)
    @ranked_page_traffic = ranked_page_traffic
  end

  def export
    File.open('page-traffic.dump', 'w+') do |file|
      file.puts(ranked_page_traffic)
    end
  end

  private

  attr_reader :ranked_page_traffic
end
