# frozen_string_literal: true

module Puma
  # Add activate_oob_worker to DSL
  class DSL
    def oob_bind(bind)
      @options[:oob_binds] ||= []
      @options[:oob_binds] << bind
    end

    def oob_worker(app: nil, min_threads: nil, max_threads: nil)
      @options[:oob_app] = app
      @options[:oob_min_threads] = min_threads
      @options[:oob_max_threads] = max_threads
    end
  end
end
