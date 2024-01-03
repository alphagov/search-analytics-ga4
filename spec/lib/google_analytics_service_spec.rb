require 'spec_helper'
require_relative '../../lib/google_analytics_service'
require 'pry'

describe GoogleAnalyticsService do
  let(:client) { double('client') }

  let(:run_report_response) do
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
      rows:
    )
  end
  let(:run_report_response_empty_rows) do
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
      rows: []
    )
  end
  let(:rows) do
    [
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
  end

  before do
    allow_any_instance_of(Client).to receive(:client).and_return(client)
    allow(client)
      .to receive(:run_report)
      .and_return(run_report_response, run_report_response_empty_rows)
  end

  describe '#get_paginated_data' do
    it 'returns the correct data' do
      data = GoogleAnalyticsService.new.get_paginated_data
      expect(data).to match_array(
        [
          have_attributes(
            class: PageData,
            path: '/',
            title: 'Welcome to GOV.UK',
            page_views: 171_078
          ),
          have_attributes(
            class: PageData,
            path: 'sign-in-universal-credit',
            title: 'Sign in to your Universal Credit account - GOV.UK',
            page_views: 184_563
          )
        ]
      )
    end

    it 'passes the correct offset and limit to the Request class' do
      expect(Request)
        .to receive(:new)
        .with(
          GoogleAnalyticsService::OFFSET,
          GoogleAnalyticsService::LIMIT
        ).and_return(
          double(
            'request',
            analytics_data: an_instance_of(Google::Analytics::Data::V1beta::RunReportRequest)
          )
        )
      expect(Request)
        .to receive(:new)
        .with(
          GoogleAnalyticsService::OFFSET + GoogleAnalyticsService::OFFSET_INCREMENT,
          GoogleAnalyticsService::LIMIT
        ).and_return(
          double(
            'request',
            analytics_data: an_instance_of(Google::Analytics::Data::V1beta::RunReportRequest)
          )
        )
      GoogleAnalyticsService.new.get_paginated_data
    end

    it 'passes the correct ga_response to the Response class' do
      expect(Response)
        .to receive(:new)
        .with(run_report_response)
        .and_return({ rows: [] })

      GoogleAnalyticsService.new.get_paginated_data
    end
  end
end
