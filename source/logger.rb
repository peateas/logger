module TMS
  class Logger
    class Factory
      def [](name)
        if defined?(@loggers) and @loggers
          result = @loggers[name]
        end
        if not result
          @default = Logger.new unless @default
          result = @default
          @default.warn("using default logger for name '#{name}'")
        end
        result
      end

    end

    class Config
    end

    class Log
      attr_reader(:device, :level)

      def initialize(device, level)
        @device = device
        @level = level
      end

      def logger
        unless defined?(@logger) and @logger
          case @device
            when :console
              @logger = ::Logger.new(STDERR)
            else
              @logger = ::Logger.new(@device)
          end
          @logger.level=@level
        end
        @logger
      end

    end

    def initialize
      @name = 'default'
      @console = Log.new(:console, ::Logger::WARN)
      @default = Log.new('default.log', ::Logger::INFO)
    end

    def devices
      logs.collect { |log| log.device }
    end

    def warn message
      send(message, ::Logger::WARN)
    end

    def info message
      send(message, ::Logger::INFO)
    end

    def logs
      [@console, @default]
    end

    def send message, level
      logs.each do |log|
        log.logger.add(level, message)
      end
    end

  end
end