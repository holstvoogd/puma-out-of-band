# frozen_string_literal: true

require 'helpers'
require 'minitest/autorun'
require 'puma/configuration'

class TestConfig < Minitest::Test
  include Helpers

  def test_default_bind
    configuration = Puma::Configuration.new do |config|
      config.bind 'tcp://127.0.0.1:8080'
      config.plugin 'oob'
      config.activate_oob_worker
      config.quiet
      config.app { [200, {}, ['Hello World']] }
    end

    start_server(configuration)
    assert_includes response, 'Hello World'
    stop_server
  end

  def test_custom_bind
    configuration = Puma::Configuration.new do |config|
      config.bind 'tcp://127.0.0.1:0'
      config.plugin 'oob'
      config.activate_oob_worker bind: 'tcp://127.0.0.1:6667'
      config.quiet
      config.app { [200, {}, ['Hello World']] }
    end

    start_server(configuration)
    assert_includes response, 'Hello World'
    stop_server
  end

  def test_custom_app
    configuration = Puma::Configuration.new do |config|
      config.bind 'tcp://127.0.0.1:0'
      config.plugin 'oob'
      config.activate_oob_worker(bind: 'tcp://127.0.0.1:6668', app: ->(_) { [200, {}, ['Custom called']] })
      config.quiet
      config.app { [200, {}, ['Hello World']] }
    end

    start_server(configuration)
    refute_includes response, 'Hello World'
    assert_includes response, 'Custom called'
    stop_server
  end

  def test_plugin_disabled
    configuration = Puma::Configuration.new do |config|
      config.bind 'tcp://127.0.0.1:0'
      config.quiet
      config.app { [200, {}, ['Hello World']] }
    end

    start_server(configuration)
    assert_raises(Errno::ECONNREFUSED) { response }
    stop_server
  end
end
