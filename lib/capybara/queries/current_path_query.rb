module Capybara
  # @api private
  module Queries
    class CurrentPathQuery < BaseQuery
      def initialize(expected_path, options = {})
        @expected_path = expected_path
        @options = options
        assert_valid_keys
      end

      def resolves_for?(session)
        @actual_path = if options[:url]
          session.current_url
        else
          URI.parse(session.current_url).request_uri
        end

        if @expected_path.is_a? Regexp
          @actual_path.match(@expected_path)
        else
          @expected_path == @actual_path
        end
      end

      def failure_message
        failure_message_helper
      end

      def negative_failure_message
        failure_message_helper(' not')
      end

      private

      def failure_message_helper(negated = '')
        verb = (@expected_path.is_a?(Regexp))? 'match' : 'equal'
        "expected #{@actual_path.inspect}#{negated} to #{verb} #{@expected_path.inspect}"
      end

      def valid_keys
        [:wait]
      end
    end
  end
end
