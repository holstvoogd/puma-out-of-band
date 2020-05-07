# frozen_string_literal: true

module Puma
  # Add activate_oob_worker to DSL
  class DSL
    def activate_oob_worker(
      bind: nil,
      app: nil,
      min_threads: nil,
      max_threads: nil
    )
      @options[:oob_binds] = Array[bind] if bind
      @options[:oob_app] = app
      @options[:oob_min_threads] = min_threads
      @options[:oob_max_threads] = max_threads
      @options[:oob_active] = true
    end
  end
end
