module Protect
  class Logger
    class << self
      def debug(message)
        instance.debug("Protect: #{message}")
      end

      def info(message)
        instance.info("  \e[36m\e[1mProtect\e[22m: #{message}\e[0m")
      end

      def warn(message)
        instance.warn("  \e[33m\e[1mProtect WARNING\e[22m: #{message}\e[0m")
      end

      def error(message)
        instance.error("  \e[31m\e[1mProtect ERROR\e[22m: #{message}\e[0m")
      end

      def instance
        return @logger if @logger

        if defined?(Rails) && Rails.logger
          @logger = Rails.logger
        else
          @logger = ::Logger.new(STDOUT, level: :debug)
        end
      end
    end
  end
end
