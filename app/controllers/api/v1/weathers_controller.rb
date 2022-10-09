# frozen_string_literal: true

module Api
  module V1
    # Api controller for providing weather data
    class WeathersController < Api::BaseController
      before_action :validate_address, only: :show
      before_action :fetch_location, only: :show
      before_action :fetch_weather, only: :show

      def show
        render json: { success: true, data: @weather_data.data }
      end

      private

      def validate_address
        if params['address'].blank?
          return render json: { success: false, message: 'Address is not valid' }, status: :bad_request
        end

        @zip = params['address'].split(',').last.gsub(/\s+/, '')
      end

      def fetch_location
        error, @lat, @lon = ThirdParty::OpenStreetMap::GetLocationService.new(params[:address]).call

        render json: { success: false, message: error }, status: :not_found if error.present?
      end

      def fetch_weather
        @weather_data = ThirdParty::Meteomatics::GetWeatherDataService.new(@lat, @lon).call
        return unless @weather_data.status != 'OK'

        render json: { success: false, message: @weather_data.error_message }, status: :internal_server_error
      end
    end
  end
end
