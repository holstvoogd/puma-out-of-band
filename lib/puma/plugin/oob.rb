# frozen_string_literal: true

require 'puma/out_of_band/dsl'
require 'puma/minissl/context_builder'

Puma::Plugin.create do
  def start(launcher)
    return unless launcher.options[:oob_active]

    binds = launcher.options[:oob_binds]
    binds ||= launcher.config.options[:binds].map do |bind|
                case bind
                when /unix:/ then bind.gsub(/\.socket/, '-oob.socket')
                when /tcp|ssl/ then bind.gsub(/:(\d+)/, ':1\1')
                end
              end

    binder = Puma::Binder.new(launcher.events)
    binder.import_from_env
    binder.parse(binds, launcher.events)

    Puma::Server.new(
      launcher.options[:oob_app] || launcher.config.app,
      launcher.events
    ).tap do |server|
      server.min_threads = launcher.options[:oob_min_threads] || 0
      server.max_threads = launcher.options[:oob_max_threads] || 1
      server.inherit_binder(binder)
      server.tcp_mode! if launcher.options[:mode] == :tcp
      server.early_hints = true if launcher.options[:early_hints]
      server.leak_stack_on_error = %w[development test].include?(launcher.options[:environment])

      launcher.events.register(:state) do |state|
        case state
        when :halt
          server.halt(true)
        when :restart, :stop
          server.stop(true) unless server.shutting_down?
        end
      end
    end.run
  end
end
