require_relative './lib/google_analytics_service'
require_relative './lib/formatter'
require_relative './lib/relevancy_calculator'


class SearchAnalytics
  def self.run
    google_analytics_service = GoogleAnalyticsService.new

    paginated_data = google_analytics_service.get_paginated_data
    consolidated_page_views = Formatter.new(paginated_data).normalise_data

    relevancy_calculator = RelevancyCalculator.new(consolidated_page_views)
    puts relevancy_calculator.relevance
  end
end

SearchAnalytics.run
