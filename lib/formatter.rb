class Formatter
  PAGE_NOT_FOUND="Page not found"
  #If there are duplicate paths (or dupes also with query strings), it consolidates the page views into the base path
  #If path doesn't start with a / then return
  #if '/y/' in path then return
  #If there are query params then split them out example: ('/hello-world?foo=bar&baz=bar'), '/hello-world'))
  #Strip out trailing /
  #Make sure '/' (root path!) isn't removed when striping out the trailing /
  #Get rid of pages with the title 'Page not found - 404 - GOV.UK'
  #For each row we format by doing all of these ^ and then format into a hash of page_views, page_path, page_title

  attr_reader :ga_data
  def initialize(ga_data)
    @consolidated_page_views = {}
    @ga_data = ga_data
  end

  def normalise_data
    ga_data.each do |page_data|
      path = page_data.path
      path = replace_empty_string_with_slash(path)
      if starts_with_slash_and_is_not_a_smart_answer(path)
        path = remove_query_string(path)
        path = strip_out_trailing_slash(path)

        unless page_not_found(page_data)
          base_path = @consolidated_page_views[path]
          if base_path.nil?
            @consolidated_page_views[path] = page_data.page_views
          else
            @consolidated_page_views[path] += page_data.page_views
          end
        end
      end
    end

    @consolidated_page_views
  end

  private

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
    return path if path == "/"
    path.chomp('/')
  end

  def page_not_found(page_data)
    page_data.title.include?(PAGE_NOT_FOUND)
  end
end
