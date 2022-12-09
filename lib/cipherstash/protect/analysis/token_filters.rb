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
            token_length = @opts[:token_length]
            Array(str_or_array).flat_map do |token|
              [].tap do |out|
                (token.length - token_length + 1).times do |i|
                  out << token[i, token_length]
                end

                split_token = token.split("")
                init_ngram = [split_token[0, token_length].join]
                rest = split_token[token_length, split_token.length]

                edge_ngram =
                  rest.reduce(init_ngram) do |acc, char|
                  acc.push(acc.last + char)
                end

                out.concat(edge_ngram)
              end
            end
          end
        end
      end
    end
  end
end
