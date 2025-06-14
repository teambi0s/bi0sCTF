module Utils
  module Add
    def self.adder(original, additional, current_obj = original)
      additional.each do |key, value|
        if value.is_a?(Hash)
          if current_obj.respond_to?(key)
            next_obj = current_obj.public_send(key)
            adder(original, value, next_obj)
          else
            new_object = Object.new
            current_obj.instance_variable_set("@#{key}", new_object)
            current_obj.singleton_class.attr_accessor key
          end
        else
          current_obj.instance_variable_set("@#{key}", value)
          current_obj.singleton_class.attr_accessor key
        end
      end
      original
    end
  end
end
