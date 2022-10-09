# frozen_string_literal: true

module ThirdParty
  module Meteomatics
    # Service that provides weather
    class GetWeatherDataService < BaseApiRequestService
      attr_reader :lat, :lon, :date, :opts

      # params date and opts provided here for possible request for specific date and parameters for future usage
      # What is more service might be updated in future for requesting a range dates
      def initialize(lat, lon, date = nil, opts = nil)
        @lat = lat
        @lon = lon
        @opts = opts
        @date = date

        super(
          "https://#{ENV['WEATHER_SERVICE_USERNAME']}:#{ENV['WEATHER_SERVICE_PASSWORD']}@#{ENV['WEATHER_SERVICE_API']}",
          command,
        )
      end

      def call
        ::ThirdParty::Meteomatics::WeatherData.new(execute_get)
      end

      private

      def command
        "/#{requested_date}/#{requested_options}/#{lat},#{lon}/json"
      end

      def requested_options
        if opts.blank?
          return 't_2m:F,t_min_2m_24h:F,t_max_2m_24h:F,wind_dir_2m:d,wind_speed_2m:mph,relative_humidity_2m:p'
        end

        opts
      end

      def requested_date
        return Time.zone.now.iso8601 if date.blank?

        date.to_time.iso8601
      end
    end
  end
end
