require_relative './lib/google_analytics_service'
require_relative './lib/formatter'

class SearchAnalytics
  def self.run
    google_analytics_service = GoogleAnalyticsService.new

    paginated_data = google_analytics_service.get_paginated_data
    consolidated_page_views = Formatter.new(paginated_data).normalise_data

    pp consolidated_page_views
  end
end

SearchAnalytics.run
