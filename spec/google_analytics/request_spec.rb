require 'spec_helper'
require 'google/analytics/data/v1beta'
require_relative '../../google_analytics/request'
require 'pry'

describe Request do
  describe '#analytics_data' do
    it 'builds the correct RunReportRequest object' do
      analytics_data = Request.new(0, 100).analytics_data

      expect(analytics_data).to have_attributes(
        property: 'properties/330577055',
        offset: 0,
        limit: 100,
        metric_aggregations: [],
        order_bys: [],
        currency_code: '',
        keep_empty_rows: false,
        return_property_quota: true
      )

      expect(analytics_data.dimensions).to match_array(
        [
          have_attributes(
            class: Google::Analytics::Data::V1beta::Dimension,
            name: 'pagePath'
          ),
          have_attributes(
            class: Google::Analytics::Data::V1beta::Dimension,
            name: 'pageTitle'
          )
        ]
      )

      expect(analytics_data.metrics).to match_array(
        [
          have_attributes(
            class: Google::Analytics::Data::V1beta::Metric,
            name: 'screenPageViews',
            expression: '',
            invisible: false
          )
        ]
      )

      expect(analytics_data.date_ranges).to match_array(
        [
          have_attributes(
            class: Google::Analytics::Data::V1beta::DateRange,
            start_date: Date.today.prev_day.to_s,
            end_date: Date.today.to_s
          )
        ]
      )
    end
  end
end
