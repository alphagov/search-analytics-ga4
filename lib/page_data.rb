class PageData
  attr_reader :path, :title, :page_views
  def initialize(path, title, page_views)
    @path = path
    @title = title
    @page_views = page_views.to_i
  end
end
