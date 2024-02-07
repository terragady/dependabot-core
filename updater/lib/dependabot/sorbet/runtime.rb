# typed: true
# frozen_string_literal: true
#
require "sorbet-runtime"

module Dependabot
  module Sorbet
    module Runtime
      class InformationalError < StandardError; end

      def self.silently_report_errors!
        T::Configuration.call_validation_error_handler = lambda do |sig, opts|
          error = InformationalError.new(opts[:pretty_message])
          error.set_backtrace(caller.dup)

          Sentry.capture_exception(error)
        end
      end
    end
  end
end
