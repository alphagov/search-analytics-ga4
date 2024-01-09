# frozen_string_literal: true

class Formatter
  PAGE_NOT_FOUND = 'Page not found'

  def initialize(ga_data)
    @consolidated_page_views = {}
    @ga_data = ga_data
  end

  def consolidated_page_views
    normalise_data
    sort_by_page_views_descending
  end

  private

  attr_reader :ga_data

  def normalise_data
    ga_data.each do |page_data|
      next if page_not_found(page_data)

      path = page_data.path
      path = replace_empty_string_with_slash(path)
      next unless starts_with_slash_and_is_not_a_smart_answer(path)

      path = remove_query_string(path)
      path = strip_out_trailing_slash(path)

      increase_page_views_counter(path, page_data)
    end
  end

  def increase_page_views_counter(path, page_data)
    base_path = @consolidated_page_views[path]
    if base_path.nil?
      @consolidated_page_views[path] = page_data.page_views
    else
      @consolidated_page_views[path] += page_data.page_views
    end
  end

  def starts_with_slash_and_is_not_a_smart_answer(path)
    path.start_with?('/') && !path.include?('/y/')
  end

  def remove_query_string(path)
    path.split('?')[0].strip
  end

  def replace_empty_string_with_slash(path)
    path.empty? ? '/' : path
  end

  def strip_out_trailing_slash(path)
    return path if path == '/'

    path.chomp('/')
  end

  def page_not_found(page_data)
    page_data.title.include?(PAGE_NOT_FOUND)
  end

  def sort_by_page_views_descending
    sorted_by_page_views_desc = @consolidated_page_views.sort_by {|_key, value| value}.reverse!
    sorted_by_page_views_desc.to_h
  end
end
