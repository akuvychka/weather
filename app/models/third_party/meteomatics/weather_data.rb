# frozen_string_literal: true

module ThirdParty
  module Meteomatics
    # This model provides data for passing it to api response
    # Now logic is based on one date and location but might be extended for several dates and locations if needed
    class WeatherData
      # data example
      # {"t_2m:F"=>72.0, "t_min_2m_24h:F"=>59.8, "t_max_2m_24h:F"=>82.7,
      # "wind_dir_10m:d"=>1.1, "wind_speed_10m:ms"=>3.3, "relative_humidity_2m:p"=>50.4}

      attr_reader :status, :data, :error_message

      def initialize(data)
        @error_message = 'Third party error. Please try again later' and return if data.blank? || !data.is_a?(Hash)

        @status = data['status']
        @data = {}
        data['data'].each do |param|
          @data[param['parameter']] = param['coordinates'][0]['dates'][0]['value']
        end
      end
    end
  end
end
