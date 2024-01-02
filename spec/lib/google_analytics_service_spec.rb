require 'spec_helper'
require_relative '../../lib/google_analytics_service'
require 'pry'

describe GoogleAnalyticsService do
  let(:client) { double('client', run_report: expected_google_analytics_data) }

  let(:expected_google_analytics_data) do
    Google::Analytics::Data::V1beta::RunReportResponse.new(
      dimension_headers: [
        Google::Analytics::Data::V1beta::DimensionHeader.new(name: 'pagePath'),
        Google::Analytics::Data::V1beta::DimensionHeader.new(name: 'pageTitle')
      ],
      metric_headers: [
        Google::Analytics::Data::V1beta::MetricHeader.new(
          name: 'screenPageViews',
          type: :TYPE_INTEGER
        )
      ],
      rows: [
        Google::Analytics::Data::V1beta::Row.new(
          dimension_values: [
            Google::Analytics::Data::V1beta::DimensionValue.new(value: '/'),
            Google::Analytics::Data::V1beta::DimensionValue.new(value: 'Welcome to GOV.UK')
          ],
          metric_values: [
            Google::Analytics::Data::V1beta::MetricValue.new(value: '171078')
          ]
        ),
        Google::Analytics::Data::V1beta::Row.new(
          dimension_values: [
            Google::Analytics::Data::V1beta::DimensionValue.new(value: 'sign-in-universal-credit'),
            Google::Analytics::Data::V1beta::DimensionValue.new(value: 'Sign in to your Universal Credit account - GOV.UK')
          ],
          metric_values: [
            Google::Analytics::Data::V1beta::MetricValue.new(value: '184563')
          ]
        )
      ]
    )
  end

  before do
    allow_any_instance_of(Client).to receive(:client).and_return(client)
  end

  describe '#get_paginated_data' do
    it 'returns the correct data' do
      data = GoogleAnalyticsService.new.get_paginated_data
      expect(data).to eq([])
    end
  end
end
