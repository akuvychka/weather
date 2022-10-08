# frozen_string_literal: true

module ThirdParty
  # Base api request service that apply all required methods for making requests for third party
  class BaseApiRequestService
    attr_reader :api_url, :command, :params

    def initialize(api_url, command, params = nil)
      @api_url = api_url
      @command = command
      @params = params
    end

    def call
      raise 'Method has to be overridden'
    end

    protected

    def execute_get
      res = RestClient.get request_path, request_get_headers
      Rails.logger.info "[REQUEST]: #{request_path} => #{params&.to_json} [RESPONSE]: #{res}"
      JSON.parse(res.body)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "[REQUEST ERROR]: #{request_path} => #{params&.to_json} [ERROR]: #{e.response}"
    end

    def header
      {
        'Content-Type': 'application/json'
      }
    end

    private

    def request_path
      api_url + command
    end

    def request_get_headers
      headers = header
      headers[:params] = params if params.present?
      headers
    end
  end
end
