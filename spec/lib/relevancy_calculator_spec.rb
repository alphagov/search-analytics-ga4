require 'spec_helper'
require_relative '../../lib/relevancy_calculator'

describe RelevancyCalculator do
  describe "#relevance" do
    it 'formats relevancy JSON' do
      consolidated_data = {"/example"=>40, "/example2"=>20, "/example3"=>100}

      relevancy_calculator = RelevancyCalculator.new(consolidated_data)

      relevancy_data = relevancy_calculator.relevance.map { |rel| JSON.parse(rel) }

      expected = [
        {"index"=>{"_id"=>"/example", "_type"=>"page-traffic"}},
        {"path_components"=>["/example"], "rank_1"=>1, "vc_1"=>40, "vf_1"=>0.25},
        {"index"=>{"_id"=>"/example2", "_type"=>"page-traffic"}},
        {"path_components"=>["/example2"], "rank_1"=>2, "vc_1"=>20, "vf_1"=>0.125},
        {"index"=>{"_id"=>"/example3", "_type"=>"page-traffic"}},
        {"path_components"=>["/example3"], "rank_1"=>3, "vc_1"=>100, "vf_1"=>0.625}
      ]

      expect(relevancy_data).to eql(expected)
    end
  end
end