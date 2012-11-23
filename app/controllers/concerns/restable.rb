load 'lib/dirty.rb'
module Restable
  extend ActiveSupport::Concern

  module ClassMethods
    def set_rest_resource(options = {})
      parent_name = options[:parent] || :user
      resource_name = options[:resource] || self.name.gsub("Controller","").singularize.underscore
      resource_class = resource_name.to_s.camelcase.constantize
      resource_find_method = options[:resource_find_by] || :find
      parent_find_method = options[:parent_find_by] || :find
      edit_action = /^(edit|update|add|new|create|delete|destroy|check|my|upload|crop).*/

      self.class_eval do
        # get current resource by params[:id]
        before_filter :get_resource
        # get parent of current resource by params[:*_id]
        before_filter :get_parent
        # set page title for the page rendered by params[:action] of params[:controller]
        # before_filter :set_title
      end

      send :define_method, :get_resource do
        action = params[:action].to_sym
        is_edit = action =~ edit_action
        is_admin = params[:controller] =~ /^admin(\/|_)/
        authenticate_user! if ((is_admin || is_edit) && !current_user && !request.xhr?)
        raise CanCan::AccessDenied if (is_admin && !current_user.is_admin?)
        if params[:id] && ![options[:skip]].flatten.include?(params[:action].to_sym) 
          if resource = self.instance_variable_set("@#{options[:instance] || resource_name}", resource_class.send(resource_find_method, params[:id]))
            if action.in?(resource.ability_actions)
              authorize! action, resource
            elsif is_edit
              authorize! :edit, resource
            else
              authorize! :read, resource
            end
          end
        end
      end

      send :define_method, :get_parent do
        if parent_name && params["#{parent_name}_id".to_sym] && ![options[:skip]].flatten.include?(params[:action].to_sym)
					parent_class = (options[:parent_as] || parent_name).to_s.capitalize.constantize
					if parent = self.instance_variable_set("@#{options[:parent_instance] || parent_name}", parent_class.send(parent_find_method, params["#{parent_name}_id"]))
            (params[:action] =~ edit_action) and authorize!(:edit, parent) unless params[:id]
					end
        end
      end

      # send :define_method, :set_title do
      #   begin
      #     # resource = self.instance_variable_get("@#{resource_name}")
      #     # parent = self.instance_variable_get("@#{parent_name}")
      #     # r_name = resource.name if resource.respond_to?(:name)
      #     # p_name = parent.name if parent.respond_to?(:name)
      #     # hash_params = {:raise => true, :resource => r_name, :parent => p_name}
      #     # params.each {|k, v| hash_params.merge!(k.to_sym => v) }
      #     # @title = I18n.t("page_title.#{params[:controller]}.#{params[:action]}", hash_params)
      #   rescue I18n::MissingTranslationData => e
      #   end
      # end
    end
  end

end
