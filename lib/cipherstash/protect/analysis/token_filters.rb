module CipherStash
  module Protect
    module Analysis
      module TokenFilters
        class Base
          def initialize(opts = {})
            @opts = opts
          end
        end

        class Downcase < Base
          def perform(str_or_array)
            Array(str_or_array).map(&:downcase)
          end
        end

        class NGram < Base
          def perform(str_or_array)
            min_length = @opts[:min_length]
            max_length = @opts[:max_length]

            Array(str_or_array).flat_map do |token|
              token_length = token.length

              ngrams = [].tap do |out|
                (min_length..max_length).each do |n|
                  ngram = token.chars.each_cons(n).map(&:join)
                  out << ngram
                end
                if token_length > max_length
                  out << token
                end
              end
              ngrams.flatten
            end
          end
        end
      end
    end
  end
end
