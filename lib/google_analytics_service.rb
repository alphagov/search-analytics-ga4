require_relative '../google_analytics/client'
require_relative '../google_analytics/request'
require_relative '../google_analytics/response'
require_relative 'page_data'
require 'pry'

class GoogleAnalyticsService
  attr_accessor :ga_client, :all_data

  #LIMIT and OFFSET_INCREMENT will be set to 100k in prod
  OFFSET = 0
  LIMIT = 10_000
  OFFSET_INCREMENT = 10_000

  def initialize
    @ga_client = Client.new
    @all_data = []
  end

  def get_paginated_data
    #https://developers.google.com/analytics/devguides/reporting/data/v1/basics#navigate_long_reports
    offset = OFFSET

    loop do
      data = get_data(offset)
      break if data[:rows].empty?

      all_data << format_all_data(data[:rows])

      offset += OFFSET_INCREMENT
    end

    all_data.flatten!
  end

  private

  def format_all_data(data)
    data.map do |row|
      path = row[:dimension_values].first[:value]
      title = row[:dimension_values].last[:value]
      page_views = row[:metric_values].first[:value]

      PageData.new(path, title, page_views)
    end
  end

  def get_data(offset)
    request = Request.new(offset, LIMIT)
    ga_response = ga_client.client.run_report(request.analytics_data)
    response = Response.new(ga_response)

    response.to_h
  end
end
