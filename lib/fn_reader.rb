require "fn_reader/version"

module FnReader
  class NameError < StandardError; end
end

class Module
  # stolen from Rails mattr_accessor
  def fn_reader(*syms)
    syms.each do |sym|
      raise FnReader::NameError.new("invalid attribute name: #{sym}") unless (sym =~ /\A[_A-Za-z]\w*\z/)
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        @@#{sym} = nil unless defined? @@#{sym}
        def self.#{sym}
          @@#{sym}
        end
      EOS

      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def #{sym}
            @@#{sym}
          end
        EOS
    end
  end
end
