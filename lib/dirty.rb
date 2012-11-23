#encoding=utf-8
module Dirty
  class ActiveRecord::Base
    def class_name
      self.class.name.underscore.to_sym
    end

    def controller_name
      self.class.name.underscore.pluralize
    end

    def ability_actions
      self.class.ability_actions
    end

    def updatable_attributes
      Hash[*self.class.accessible_attributes.map { |attr| self.class.accessible_attributes.include?(attr.to_s) ? [attr, self.send(attr)] : nil }.compact.flatten]
    end

    def unvalidate_update!(params)
      params and params.each do |k, v|
        if self.class.accessible_attributes.include?(k.to_s) 
          self.send("#{k}=", v) unless v.blank? && v == self.send(k)
        else
          k != "id" and logger.info "#{k} is not accessible for #{self.class.name}"
        end
      end
      save!(:validate => false) and reload
    end

    def self.ability_actions
      @ability_actions || set_ability_actions
    end

    def self.set_ability_actions
      ability = Ability.new(User.new)
      @ability_actions = [ability.send(:rules).map do |rule| 
        rule.subjects.first==self and ability.send(:relevant_rules, rule.actions.first, self).first.instance_eval{@expanded_actions}
      end].flatten!.compact.uniq.delete_if {|action| [:show, :index].include?(action)}
    end

    def self.unvalidate_create!(attrs={})
      resource = self.new(attrs)
      resource.save!(:validate => false)
      resource
    end

  end

  class ActiveSupport::TimeWithZone
    def to_china
      strftime("%Y年%m月%d日 %H时%M分")
    end
    def todate
      strftime("%Y年%m月%d日")
    end
  end

  module ActionView::Helpers

    module UrlHelper
      def current_page?(options)
        unless request
          raise "You cannot use helpers that need to determine the current page unless your view context provides a Request object in a #request method"
        end

        return false unless request.get?

        url_string = url_for(options).downcase

        # We ignore any extra parameters in the request_uri if the
        # submitted url doesn't have any either. This lets the function
        # work with things like ?order=asc
        if url_string.index("?")
          request_uri = request.fullpath
        else
          request_uri = request.path
        end

        request_uri = request_uri.downcase

        if url_string =~ /^\w+:\/\//
          url_string == "#{request.protocol}#{request.host_with_port}#{request_uri}"
        else
          url_string == request_uri
        end
      end
    end

    # module AssetTagHelper
    
    #   def image_tag(source, options = {})
    #     options.symbolize_keys!

    #     src = options[:src] = path_to_image("#{source}?#{ENV['timestamp']}")

    #     unless src =~ /^(?:cid|data):/ || src.blank?
    #       options[:alt] = options.fetch(:alt){ image_alt(src) }
    #     end

    #     if size = options.delete(:size)
    #       options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
    #     end

    #     if mouseover = options.delete(:mouseover)
    #       options[:onmouseover] = "this.src='#{path_to_image(mouseover)}'"
    #       options[:onmouseout]  = "this.src='#{src}'"
    #     end

    #     tag("img", options)
    #   end
      
    # end

  end

end

module ActiveSupport
  class TaggedLogging
    def custom(exception, request)
      exception.is_a?(Exception) or return
      str = "\n|----0-_-0----|         "
      info "*" * 75 + "log info START" + "*" * 75 + "\n"
      info "#{str}:  #{exception.message}\n"
      info str + exception.backtrace[0..7].join(str) + "\n"
      info "*" * 75 + "log info END" + "*" * 75 + "\n\n"
      unless Rails.env.development? || request.user_agent.match(/\(.*https?:\/\/.*\)/)
        ExceptionNotifier::Notifier.exception_notification(request.env, exception, :data => {:message => "出错了。"}).deliver 
      end
    end
  end
end

class Array
  def file_validations
    {}.tap do |hash|
      self.each do |v|
        hash.merge!(:required => v) if v.is_a?(Paperclip::Validators::AttachmentPresenceValidator)
        hash.merge!(:type => v) if v.is_a?(Paperclip::Validators::AttachmentContentTypeValidator)
        hash.merge!(:size => v) if v.is_a?(Paperclip::Validators::AttachmentSizeValidator)
      end
    end
  end
end

module Rails
  class << self

    def host
      Settings.host.send(Rails.env)
    end

  end
end

module Paperclip
  module Helpers
    def process_image(input, output, size = "150x150")
      Paperclip.run("convert", ":in -scale :resolution :out",:in => input, :out=> output, :resolution => size)
    end
  end
end
