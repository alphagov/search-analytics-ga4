require "google/analytics/data/v1beta"
require 'dotenv'
Dotenv.load

class Client
  attr_reader :client
  def initialize
    @client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
  end
end