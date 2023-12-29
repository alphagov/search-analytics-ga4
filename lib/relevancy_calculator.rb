require 'json'

class RelevancyCalculator
  def initialize(consolidated_data)
    @consolidated_data = consolidated_data
  end

  def relevance
    formatted = []
    consolidated_data.each.with_index(1) do |data, idx|
      base_path = data.first
      page_views = data.last
       elastic_search_index =  {
        index: {
          _type: "page-traffic",
          _id: base_path
        }
      }
      rank = {
        path_components: [base_path],
        rank_1: idx,
        vc_1: page_views,
        vf_1: data.last.to_f  / total_page_views.to_f
      }
      formatted << elastic_search_index.to_json
      formatted << rank.to_json
    end
    formatted
  end

  private

  attr_reader :consolidated_data

  def total_page_views
    all_page_views = consolidated_data.values
    all_page_views.reduce(:+)
  end
end