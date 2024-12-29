class Class
    @@method_history = {}

    def self.method_history
        return @@method_history
    end

   def method_added(method_name)
       @@method_history[self.name] ||= {}
       if @@method_history[self.name].key?(method_name)
         puts "\r\nWARNING: #{method_name} monkey patched in #{self.name}\r\n\r\n"
       end
       @@method_history[self.name][method_name] = caller
   end

   def method_defined_in(method_name)
       return @@method_history[self.name][method_name]
   end
 end