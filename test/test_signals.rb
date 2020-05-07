# frozen_string_literal: true

require_relative 'helpers'
require 'minitest/autorun'
require 'puma/configuration'

class TestSignals < Minitest::Test
  include Helpers

  def test_stop
    start_server(
      Puma::Configuration.new do |config|
        config.plugin 'oob'
        config.bind 'tcp://127.0.0.1:8081'
        config.quiet
        config.app { [200, {}, ['Hello World']] }
      end
    )
    @launcher.stop
    sleep 1
    assert_raises(Errno::ECONNREFUSED) { response }
    stop_server
  end
end
