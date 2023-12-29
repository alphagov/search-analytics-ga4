require_relative './lib/google_analytics_service'
require_relative './lib/formatter'
require_relative './lib/relevancy_calculator'
require_relative './lib/page_traffic_writer'

class SearchAnalytics
  def self.run
    google_analytics_service = GoogleAnalyticsService.new

    paginated_data = google_analytics_service.get_paginated_data
    consolidated_page_views = Formatter.new(paginated_data).normalise_data

    relevancy_calculator = RelevancyCalculator.new(consolidated_page_views)
    page_traffic_writer = PageTrafficWriter.new(relevancy_calculator.relevance)
    page_traffic_writer.export
  end
end

SearchAnalytics.run
