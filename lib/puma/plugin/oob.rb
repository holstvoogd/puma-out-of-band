# frozen_string_literal: true

require 'puma/out_of_band/dsl'
require 'puma/out_of_band/server'
require 'puma/minissl/context_builder'

Puma::Plugin.create do
  def start(launcher)
    return if launcher.options[:oob_binds].empty?

    binder = Puma::Binder.new(launcher.events)
    binder.import_from_env
    binder.parse(launcher.options[:oob_binds], launcher.events)

    Puma::Server.new(
      launcher.options[:oob_app] || launcher.config.app
    ).tap do |server|
      server.min_threads = launcher.options[:oob_min_threads] || 0
      server.max_threads = launcher.options[:oob_max_threads] || 1
      server.inherit_binder(binder)
      server.tcp_mode! if launcher.options[:mode] == :tcp
      server.early_hints = true if launcher.options[:early_hints]
      server.leak_stack_on_error = %w[development test].include?(launcher.options[:environment])

      launcher.events.register(:on_booted) do
        server.run(true) unless server.running
      end
    end
  end
end
