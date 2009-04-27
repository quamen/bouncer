# Bouncer

class ActionController::Base
  def self.allow_assignment(*assignable_attributes_hash)
    assignable_attributes_hash.each do |attribute_hash|
      attribute_hash.keys.each do |key|
        before_filter { |controller| controller.send(:slice_attributes_for, key, attribute_hash[key]) }
      end
    end
  end
  
  private

  def slice_attributes_for(params_hash_symbol, assignable_attributes)
    params[params_hash_symbol].slice!(*assignable_attributes) if params[params_hash_symbol]
  end
end
