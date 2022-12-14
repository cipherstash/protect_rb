# Implementation copied over from the Ruby Client
# https://github.com/cipherstash/ruby-client/blob/main/lib/cipherstash/analysis/text_processor.rb
module CipherStash
  module Protect
    module Analysis
      # General (but very simple) string processor
      # based on settings from a secure_text_search field in the model.
      #
      class TextProcessor
        # Creates a new string processor for the given field settings
        #
        # @param settings [Hash] the field settings
        #
        # ## Example
        #
        # TextProcessor.new({
        #   token_filters: [
        #     {kind: :downcase},
        #     {kind: :ngram, min_length: 3, max_length: 8}
        #   ],
        #   tokenizer: {kind: :standard}
        # })
        #
        def initialize(settings)
          @token_filters = build_token_filters(settings[:token_filters])
          @tokenizer = build_tokenizer(settings[:tokenizer])
        end

        # Processes the given str and returns an array of tokens (the "Vector")
        #
        # @param str [String] the string to process
        # @return [String]
        #
        def perform(str)
          tokens = @tokenizer.perform(str)
          @token_filters.inject(tokens) do |result, stage|
            stage.perform(result)
          end
        end

        private
        def build_token_filters(array)
          raise CipherStash::Protect::Error, "No token filters provided." unless array && array.length > 0
          array.map do |obj|
            case obj[:kind]
            when :downcase
              TokenFilters::Downcase.new(obj)

            when :ngram
              unless obj[:min_length] && obj[:max_length]
                raise CipherStash::Protect::Error, "Min length and max length not provided with ngram filter. Please specify ngram token length using '{kind: :ngram, min_length: 3, max_length: 8}'"
              end

              unless obj[:min_length].instance_of?(Integer) && obj[:max_length].instance_of?(Integer)
                raise CipherStash::Protect::Error, "The values provided to the min and max length must be of type Integer."
              end

              unless obj[:max_length] >= obj[:min_length]
                 raise CipherStash::Protect::Error, "The ngram filter min length must be less than or equal to the max length"
              end

              TokenFilters::NGram.new(obj)

            else
              raise CipherStash::Protect::Error, "Unknown token filter: '#{obj[:kind]}'"
            end
          end
        end

        def build_tokenizer(obj)
          raise CipherStash::Protect::Error, "No tokenizer provided. Use tokenizer: {kind: :standard} in your settings." unless obj

          if obj[:kind] == :standard
            Tokenizer::Standard.new
          else
            raise CipherStash::Protect::Error, "Unknown tokenizer: '#{obj[:kind]}'. Use tokenizer: {kind: :standard} in your settings."
          end
        end
      end
    end
  end
end
