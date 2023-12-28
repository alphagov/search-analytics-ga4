require_relative '../google_analytics/client'
require_relative '../google_analytics/request'
require_relative '../google_analytics/response'

class GoogleAnalyticsService
  attr_accessor :ga_client, :all_data

  def initialize
    @ga_client = Client.new
    @all_data = []
  end

  def get_data(offset, limit)
    request = Request.new(offset, limit)
    ga_response = ga_client.client.run_report(request.analytics_data)
    response = Response.new(ga_response)

    response.to_h
  end

  def get_paginated_data
    #https://developers.google.com/analytics/devguides/reporting/data/v1/basics#navigate_long_reports
    offset = 0
    limit = 10

    while true do
      data = get_data(offset, limit)
      break if data[:rows].empty?

      all_data << data

      #Setting to 10 for now, will need to be 100k in prod
      offset += 10
      limit += 10
    end
    puts all_data
    all_data
  end
end

google_analytics_service = GoogleAnalyticsService.new
google_analytics_service.get_paginated_data
