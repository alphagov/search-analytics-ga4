require_relative 'google_analytics/client'
require_relative 'google_analytics/request'
require_relative 'google_analytics/response'

class GoogleAnalyticsService
  attr_accessor :ga_client
  def initialize
    @ga_client = Client.new
    @all_data = []
  end

  def get_data(offset, limit)
    request = Request.new(offset, limit)
    ga_response = ga_client.client.run_report(request.analytics_data)
    response = Response.new(ga_response)
    puts response.to_h
    response.to_h
  end

  # def get_all_data
  #   #TODO - at the moment the data is paginated... need to iterate
  #   #over the pages and store the data in all_data
  #   #https://developers.google.com/analytics/devguides/reporting/data/v1/basics#navigate_long_reports
  #   #the offset and limit can increase by 100k each time... need to do until rows [] is empty
  #   unless response.to_h[:rows].empty?

  #   end
  # end
end

google_analytics_service = GoogleAnalyticsService.new
google_analytics_service.get_data(0, 10)