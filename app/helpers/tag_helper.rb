module TagHelper
  def tag_filter_link(tag)
    active = params[:tag].to_s == tag.name
    link_to tag.name.capitalize,
            tasks_path(tag: tag.name, title: params[:title]),
            class: tag_sidebar_link_class(active)
  end

  def tag_sidebar_link_class(active)
    base_class = "group flex items-center px-2 py-2 text-md font-medium rounded-md"
    if active
      "#{base_class} bg-green-100 text-green-900"
    else
      "#{base_class} text-gray-600 hover:bg-gray-50 hover:text-gray-900"
    end
  end

  def render_tag_filters
    Tag.order(:name).map do |tag|
      tag_filter_link(tag)
    end.join.html_safe
  end
end
