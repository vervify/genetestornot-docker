# Fix for Rails 4.2 + Postgres rejecting client_min_messages = 'panic'
# Map it to 'error' instead.
if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  module ActiveRecord
    module ConnectionAdapters
      class PostgreSQLAdapter
        def client_min_messages=(level)
          level = 'error' if level.to_s == 'panic'
          execute("SET client_min_messages TO '#{level}'", 'SCHEMA')
        end
      end
    end
  end
end
