# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThirdParty::OpenStreetMap::GetLocationService, type: :service do
  describe '#call' do
    subject(:service_call) { described_class.new(address).call }

    let(:address) { "#{FFaker::AddressUS.street_address}, #{FFaker::AddressUS.city}, #{FFaker::AddressUS.zip_code}" }
    let(:lat) { FFaker::Geolocation.lat }
    let(:lon) { FFaker::Geolocation.lng }
    let(:response_data) { object_double('HttpResponse', body: [{lat: lat, lon: lon}].to_json) }

    before do
      ENV['LOCATION_SERVICE_API'] = FFaker::Internet.http_url
      allow(RestClient).to receive(:get).and_return(response_data)
    end

    it 'has to return geo location' do
      expect(service_call).to eq([nil, lat, lon])
    end

    context 'when location has not be found' do
      let(:response_data) { object_double('HttpResponse', body: [].to_json) }
      it 'has return error message' do
        expect(service_call).to eq('Location not existed')
      end
    end
  end
end