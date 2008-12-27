module ActionView #:nodoc:
  module Helpers #:nodoc:
    module NestedLayoutsHelper
      BINDING_REQUIRED = !!((Object.const_defined?(:Rails) && Rails.respond_to?(:version) ? 
          Rails.version : RAILS_GEM_VERSION) < '2.2.0')

      # Wrap part of the template into layout.
      # All layout files must be in app/views/layouts.
      def inside_layout(layout, &block)
        binding = block.binding if BINDING_REQUIRED

        layout = Dir.entries('app/views/layouts').detect { |a| /#{layout}/.match(a) }
        @template.instance_variable_set('@content_for_layout', capture(&block))
        concat(
          @template.render(:file => "#{RAILS_ROOT}/app/views/layouts/#{layout}", :user_full_path => true),
          binding
        )
      end

      # Wrap part of the template into inline layout.
      # Same as +inside_layout+ but takes layout template content rather than layout template name.
      def inside_inline_layout(template_content, &block)
        binding = block.binding if BINDING_REQUIRED

        @template.instance_variable_set('@content_for_layout', capture(&block))
        concat( @template.render( :inline => template_content ), binding )
      end
    end
  end
end
