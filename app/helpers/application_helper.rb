module ApplicationHelper

  def nav_link(link_text, link_path, link_icon)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to link_path do
        "<i class='fa fa-#{link_icon}'></i> #{link_text}".html_safe
      end
    end
  end

  def nav_sub_link(link_path)
    class_name = ''
    link_path.each do |link|
      return 'active open' if current_page?(link)
    end
  end
end
