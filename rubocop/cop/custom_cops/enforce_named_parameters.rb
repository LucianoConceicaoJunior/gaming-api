# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module CustomCops
      class EnforceNamedParameters < RuboCop::Cop::Base
        extend AutoCorrector
        INSTRUCTION_MESSAGE = 'Use keyword/named parameters.'

        # rubocop:disable CustomCops/EnforceNamedParameters
        # Triggered for instance methods
        def on_def(node)
          check_method_parameters(node:)
        end

        # Triggered for class methods
        def on_defs(node)
          check_method_parameters(node:)
        end
        # rubocop:enable CustomCops/EnforceNamedParameters

        private

        def check_method_parameters(node:)
          parameters = node.arguments

          return if named_parameters?(parameters:)
          return if args_or_block?(parameters:)
          return if parameters.empty?

          add_offense(node.arguments, message: INSTRUCTION_MESSAGE) do |corrector|
            autocorrect_positional_to_named(corrector:, node:)
          end
        end

        # Check if parameter is of type *args or &block
        def args_or_block?(parameters:)
          parameters.any? do |parameter|
            parameter.splat_type? || parameter.blockarg_type?
          end
        end

        def named_parameters?(parameters:)
          parameters.any? do |parameter|
            %i[kwarg kwoptarg kwrestarg].include?(parameter.type)
          end
        end

        def autocorrect_positional_to_named(corrector:, node:)
          parameters = node.arguments

          corrected_params = parameters.map do |parameter|
            if parameter.optarg_type?
              "#{parameter.children[0]}: #{parameter.children[1].source}"
            else
              "#{parameter.source}:"
            end
          end.join(', ')

          corrected_version = if node.loc.expression.source.include?('(')
                                "(#{corrected_params})"
          else
                                corrected_params
          end

          corrector.replace(parameters.source_range, corrected_version)
        end
      end
    end
  end
end
