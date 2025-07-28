# frozen_string_literal: true

class StatisticsCardComponent < ViewComponent::Base
  def initialize(title_key:, count:, color_class: "text-gray-900")
    @title_key = title_key
    @count = count
    @color_class = color_class
  end
end
