class PageTrafficWriter
  attr_reader :ranked_page_traffic
  def initialize(ranked_page_traffic)
    @ranked_page_traffic = ranked_page_traffic
  end

  def export
    File.open("page-traffic.dump", "w+") do |file|
      ranked_page_traffic.each { |element| file.puts(element) }
    end
  end
end