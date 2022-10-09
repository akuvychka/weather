# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::WeathersController, type: :controller do
  describe '#show' do
    subject(:request_weather) { get :show, params: { address: address } }

    let(:address) { "#{FFaker::AddressUS.street_address}, #{FFaker::AddressUS.city}, #{zip_code}" }
    let(:zip_code) { FFaker::AddressUS.zip_code }
    let(:location_service_instance) { double }
    let(:weather_service_instance) { double }
    let(:lat) { FFaker::Geolocation.lat }
    let(:lon) { FFaker::Geolocation.lng }
    let(:weather_data) do
      object_double("WeatherData", status: 'OK', data: { param1: FFaker::Lorem.word })
    end

    before do
      allow(ThirdParty::OpenStreetMap::GetLocationService).to receive(:new).and_return(location_service_instance)
      allow(location_service_instance).to receive(:call).and_return([nil, lat, lon])
      allow(ThirdParty::Meteomatics::GetWeatherDataService).to receive(:new).and_return(weather_service_instance)
      allow(weather_service_instance).to receive(:call).and_return(weather_data)
      allow(RedisCacheStore).to receive(:get).and_return(nil)
      allow(RedisCacheStore).to receive(:set_with_ttl).and_return('OK')
    end

    it 'has to be successful' do
      request_weather

      expect(response).to be_successful
      expect(parsed[:data]).to eq(weather_data.data)
      expect(parsed[:cached]).to be(false)
      expect(ThirdParty::OpenStreetMap::GetLocationService).to have_received(:new).with(address)
      expect(ThirdParty::Meteomatics::GetWeatherDataService).to have_received(:new).with(lat, lon)
      expect(RedisCacheStore).to have_received(:get).with(zip_code)
      expect(RedisCacheStore).to have_received(:set_with_ttl).with(zip_code, weather_data.data)
    end

    context 'when address is empty' do
      let(:address) { '' }

      it 'has to return error' do
        request_weather

        expect(response).not_to be_successful
        expect(response.status).to eq(400)
        expect(parsed[:message]).to eq('Address is not valid')
        expect(RedisCacheStore).to_not have_received(:set_with_ttl)
        expect(ThirdParty::Meteomatics::GetWeatherDataService).to_not have_received(:new)
      end
    end

    context 'when provided address has not be found' do
      let(:error_message) { FFaker::Lorem.sentence }

      before { allow(location_service_instance).to receive(:call).and_return(error_message) }

      it 'has to return error' do
        request_weather

        expect(response).not_to be_successful
        expect(response.status).to eq(404)
        expect(parsed[:message]).to eq(error_message)
        expect(RedisCacheStore).to_not have_received(:set_with_ttl)
        expect(ThirdParty::Meteomatics::GetWeatherDataService).to_not have_received(:new)
      end
    end

    context 'when weather service return an error' do
      let(:error_message) { FFaker::Lorem.sentence }
      let(:weather_data) do
        object_double("WeatherData", status: '', error_message: error_message)
      end

      it 'has to return error' do
        request_weather

        expect(response).not_to be_successful
        expect(response.status).to eq(500)
        expect(parsed[:message]).to eq(error_message)
        expect(RedisCacheStore).to_not have_received(:set_with_ttl)
      end
    end

    context 'when have a stored data' do
      before { allow(RedisCacheStore).to receive(:get).and_return(weather_data.data) }

      it 'has to be successful' do
        request_weather

        expect(response).to be_successful
        expect(parsed[:data]).to eq(weather_data.data)
        expect(parsed[:cached]).to be(true)
        expect(ThirdParty::OpenStreetMap::GetLocationService).to_not have_received(:new)
        expect(ThirdParty::Meteomatics::GetWeatherDataService).to_not have_received(:new)
        expect(RedisCacheStore).to have_received(:get).with(zip_code)
        expect(RedisCacheStore).to_not have_received(:set_with_ttl)
      end
    end
  end
end