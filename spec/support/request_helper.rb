# frozen_string_literal: true

module RequestHelper
  def parsed
    @parsed ||= JSON.parse(response.body, symbolize_names: true)
  end
end
