module Radar
    class Event
      attr_reader :data

    def initialize(exception)
      @data = {
        timestamp: Time.now.to_i,
        server_data: server_data,
        configuration: Radar.configuration.get,
        message: exception.message,
        backtrace: exception.backtrace,
      }
    end

    def server_data
      @server_data ||= {
        host: Socket.gethostname,
        pid: Process.pid
      }
    end
  end
end
