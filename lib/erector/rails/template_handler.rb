module Erector
  module Rails
    class TemplateHandler

      if defined?(ActionView) && defined?(Rails) && Rails.respond_to?(:version) && Rails.version.to_s.match?(/^[345]/)
        def call(template)
          require_dependency template.identifier
          widget_class_name = "views/#{template.identifier =~ %r(views/([^.]*)(\..*)?\.rb) && $1}".camelize
          is_partial = File.basename(template.identifier) =~ /^_/
          <<-SRC
        Erector::Rails.render(#{widget_class_name}, self, local_assigns, #{!!is_partial})
        SRC
        end
      end

      if defined?(ActionView) && defined?(Rails) && Rails.respond_to?(:version) && Rails.version.to_s.match?(/^[67]/)
        def call(template, source)
          require_dependency template.identifier
          widget_class_name = "views/#{template.identifier =~ %r(views/([^.]*)(\..*)?\.rb) && $1}".camelize
          is_partial = File.basename(template.identifier) =~ /^_/
          <<-SRC
        Erector::Rails.render(#{widget_class_name}, self, local_assigns, #{!!is_partial})
        SRC
        end
      end
    end
  end
end

ActionView::Template.register_template_handler :rb, Erector::Rails::TemplateHandler.new
