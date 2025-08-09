ActiveSupport.on_load(:active_record) do
  next unless defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)

  module ClientMinMessagesPatch
    def client_min_messages=(level)
      lvl = level.to_s
      # Some old configs use "fatal"; AR maps that to "panic" for client_min_messages.
      lvl = 'error' if lvl == 'panic' || lvl == 'fatal'
      super(lvl)
    end
  end

  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(ClientMinMessagesPatch)
end