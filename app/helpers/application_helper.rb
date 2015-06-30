module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    getCurrentYear = Date.current.year
    base_title = "Sodbury Challenge #{getCurrentYear}"
    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end

end
