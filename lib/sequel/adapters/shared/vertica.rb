module Sequel
  module Vertica
    module DatabaseMethods
      extend Sequel::Database::ResetIdentifierMangling

      TEMPORARY = 'TEMP '.freeze

      # Vertica uses the :vertica database type
      def database_type
        :vertica
      end

      private

      def connection_configuration_sqls
        sqls = []
        if search_path = @opts[:search_path]
          case search_path
          when String
            search_path = search_path.split(",").map{|s| s.strip}
          when Array
            # nil
          else
            raise Error, "unrecognized value for :search_path option: #{search_path.inspect}"
          end
          sqls << "SET search_path = #{search_path.map{|s| "\"#{s.gsub('"', '""')}\""}.join(',')}"
        end

        sqls
      end


      # SQL fragment for showing a table is temporary
      def temporary_table_sql
        TEMPORARY
      end
    end
    
    module DatasetMethods
      #so order of the clause methods matters here with regards to how the cluases are added to the sql
      #being constructed for the querry.
      SELECT_CLAUSE_METHODS = Dataset.clause_methods(:select, %w'select distinct columns from join where group having compounds order limit lock')
      LIMIT = " LIMIT ".freeze
      OFFSET = " OFFSET ".freeze

      private

      def select_clause_methods
        SELECT_CLAUSE_METHODS
      end

      def select_limit_sql(sql)
        if o = @opts[:offset]
          raise Error, "Using OFFSET with Vertica returns an undefined subset" +
            " of the result set without an order by clause" unless @opts[:order]
          sql << OFFSET 
          literal_append(sql, o)
        end
        if l = @opts[:limit]
          sql << LIMIT 
          literal_append(sql, l)
        end
      end

    end
  end
end
