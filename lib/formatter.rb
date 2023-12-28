class Formatter
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
    ga_data = ga_data
  end

  def call
    ga_data
  end
end