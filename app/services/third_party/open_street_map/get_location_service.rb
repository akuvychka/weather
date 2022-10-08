# frozen_string_literal: true

module ThirdParty
  module OpenStreetMap
    # Service that provides search for location using OpenStreetMap
    class GetLocationService < BaseApiRequestService
      REQUEST_COMMAND = '/search'

      def initialize(address)
        super(ENV['LOCATION_SERVICE_API'], REQUEST_COMMAND, { q: address, format: 'json' })
      end

      def call
        locations_list = execute_get
        return 'Location not existed' unless locations_list.count.positive?

        # Here might be more complex logic to define location
        # What is more result might me full object for any other needs
        # but for the current needs I am going to return only lat and lon for the first found location

        [nil, locations_list[0]['lat'], locations_list[0]['lon']]
      end
    end
  end
end
