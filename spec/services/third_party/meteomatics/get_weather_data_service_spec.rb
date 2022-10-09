# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThirdParty::Meteomatics::GetWeatherDataService, type: :service do
  describe '#call' do
    subject(:service_call) { described_class.new(lat, lon).call }

    let(:lat) { FFaker::Geolocation.lat }
    let(:lon) { FFaker::Geolocation.lng }
    let(:response_data) { object_double('HttpResponse', body: response_json.to_json) }
    let(:response_json) do
      {
        status: 'OK',
        data: [
          { parameter: "t_2m:F", coordinates: [{ dates: [{ value: 75 }]}]},
          { parameter: "wind_speed_2m:mph", coordinates: [{ dates: [{ value: 12 }]}]},
        ],
      }
    end
    let(:correct_data) do
      {
        "t_2m:F": 75,
        "wind_speed_2m:mph": 12,
      }.stringify_keys
    end

    before do
      ENV['LOCATION_SERVICE_API'] = FFaker::Internet.http_url
      allow(RestClient).to receive(:get).and_return(response_data)
    end

    it 'has to return geo location' do
      model = service_call
      expect(model.status).to eq('OK')
      expect(model.data).to eq(correct_data)
    end

    context 'when location has not be found' do
      let(:response_json) { "Some text error message from third party system" }

      it 'has return error message' do
        model = service_call
        expect(model.status).to be_nil
        expect(model.error_message).to eq('Third party error. Please try again later')
      end
    end
  end
end