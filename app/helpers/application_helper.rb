module ApplicationHelper
  # returns the full title on a per-page basis
  def full_title page_title
    title = "Ruby on Rails Tutorial Sample App"
    title << " | #{page_title}" unless page_title.empty?
    title
  end
end
