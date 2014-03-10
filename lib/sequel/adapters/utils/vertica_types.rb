module Sequel

  module Vertica
    NAN             = 0.0/0.0
    PLUS_INFINITY   = 1.0/0.0
    MINUS_INFINITY  = -1.0/0.0
    NAN_STR             = 'NaN'.freeze
    PLUS_INFINITY_STR   = 'Infinity'.freeze
    MINUS_INFINITY_STR  = '-Infinity'.freeze
    TRUE_STR = 't'.freeze
    DASH_STR = '-'.freeze
    
    TYPE_TRANSLATOR = tt = Class.new do
      def boolean(s) s == TRUE_STR end
      def integer(s) s.to_i end
      def float(s) 
        case s
        when NAN_STR
          NAN
        when PLUS_INFINITY_STR
          PLUS_INFINITY
        when MINUS_INFINITY_STR
          MINUS_INFINITY
        else
          s.to_f 
        end
      end
    end.new
  
  end
end 
