# Bouncer

class ActionController::Base
  before_filter :cache_params_hash
  
  def self.allow_assignment(*assignable_attributes_hash)    
    assignable_attributes_hash.each do |attribute_hash|
      attribute_hash.keys.each do |key|
        before_filter { |controller| controller.send(:slice_attributes_for, key, attribute_hash[key]) }
      end
    end
  end
  
  private
  
  def cache_params_hash
    @cached_params_hash = params.dup
    keys = [:authenticity_token, :_method]
    keys += self.request.env['rack.routing_args'].keys
    params.slice!(*keys)
  end

  def slice_attributes_for(params_hash_symbol, assignable_attributes)
    if @cached_params_hash[params_hash_symbol]
      allowed_attributes = @cached_params_hash[params_hash_symbol].slice(*assignable_attributes) 
      params[params_hash_symbol] = allowed_attributes
    end
  end
end
