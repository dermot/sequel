Sequel.require 'adapters/shared/vertica'
Sequel.require 'adapters/jdbc/transactions'


module Sequel
  module JDBC
    # Database and Dataset instance methods for Vertica specific
    # support via JDBC.
    module Vertica
      # Database instance methods for Vertica databases accessed via JDBC.
      module DatabaseMethods
        extend Sequel::Database::ResetIdentifierMangling
        include Sequel::Vertica::DatabaseMethods
        include Sequel::JDBC::Transactions
        
        # Execute the connection configuration SQL queries on the connection.
        def setup_connection(conn)
          conn = super(conn)
          statement(conn) do |stmt|
            connection_configuration_sqls.each{|sql| log_yield(sql){stmt.execute(sql)}}
          end
          conn
        end

      end
    end
  end
end
