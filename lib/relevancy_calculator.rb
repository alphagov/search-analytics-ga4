require 'json'

class RelevancyCalculator
  def initialize(consolidated_data)
    @consolidated_data = consolidated_data
  end

  def relevance
    consolidated_data.map.with_index(1) do |(base_path, page_views), index|
      [
        elastic_search_index(base_path).to_json,
        elastic_search_rank(base_path, index, page_views).to_json
      ]
    end.flatten
  end

  private

  attr_reader :consolidated_data

  def elastic_search_index(base_path)
    {
      index: {
        _type: 'page-traffic',
        _id: base_path
      }
    }
  end

  def elastic_search_rank(base_path, index, page_views)
    {
      path_components: [base_path],
      rank_1: index,
      vc_1: page_views,
      vf_1: page_views / total_page_views.to_f
    }
  end

  def total_page_views
    all_page_views = consolidated_data.values
    all_page_views.reduce(:+)
  end
end
