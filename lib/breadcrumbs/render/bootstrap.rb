class Breadcrumbs
  module Render
    class Bootstrap < List # :nodoc: all

      attr_reader :separator

      # @overload
      def initialize(*)
        super
        @separator = options.delete(:separator)
      end

      # @overload
      def default_options
        super.merge(:class => "breadcrumb", :separator => "/")
      end

      # @overload
      def render_item(item, i, size)
        html_opts, suffix = {},  nil
        if i == size - 1
          html_opts.update :class => "active"
        elsif separator
          suffix = tag(:span, separator, :class => "divider")
        end

        text, url, options = *item
        text = [escape(text), suffix].join
        text = wrap_item(url, text, options)
        tag(:li, text, html_opts)
      end

      protected

      # @overload
      def wrap_item(url, text, *)
        url ? tag(:a, text, :href => url) : text
      end

    end
  end
end
