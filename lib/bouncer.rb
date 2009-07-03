# Bouncer
class ActionController::Base
  before_filter :cache_params_hash
  
  def self.allow_params(*param_sets)
    param_sets.each do |param|
      if param.respond_to? :to_sym
        before_filter { |controller| controller.send(:slice_attribute, param)}
      elsif
        param.keys.each do |key|
          before_filter { |controller| controller.send(:slice_attributes_for, key, param[key]) }
        end
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

  def slice_attribute(param_key)
    if @cached_params_hash[param_key]
      allowed_attribute = @cached_params_hash[param_key]
      params[param_key] = allowed_attribute
    end
  end
  
  def slice_attributes_for(param_key, assignable_attributes)
    if @cached_params_hash[param_key]
      allowed_attributes = @cached_params_hash[param_key].slice(*assignable_attributes) 
      params[param_key] = allowed_attributes
    end
  end
end
