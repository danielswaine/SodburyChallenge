module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    current_year = Date.current.year
    base_title = "Sodbury Challenge #{current_year}"
    if page_title.to_s.empty?
      base_title
    else
      page_title + ' - ' + base_title
    end
  end
end
