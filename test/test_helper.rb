require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
ENV["RAILS_ENV"] ||= "test"

module ActiveSupport
  class TestCase
    include ApplicationHelper
    fixtures :all

    def is_logged_in?
      !session[:user_id].nil?
    end
  end
end
