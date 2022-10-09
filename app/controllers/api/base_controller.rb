# frozen_string_literal: true

module Api
  # Base api controller
  class BaseController < ApplicationController
    before_action :authenticate_user!

    def authenticate_user!
      # do check user if existed or open key or any other auth params
      true
    end
  end
end
