class Breadcrumbs
  module Render
    class List < Base # :nodoc: all

      attr_reader :list_style

      # @overload
      def initialize(*)
        super
        @list_style = options.delete(:tag) || :ul
      end

      # @overload
      def default_options
        super.merge(:tag => :ul)
      end

      # @overload
      def render
        tag(list_style, options) do
          html = ""
          size = breadcrumbs.size

          breadcrumbs.each_with_index do |item, i|
            html << render_item(item, i, size)
          end

          html
        end
      end

      def render_item(item, i, size)
        css = []
        css << "first" if i == 0
        css << "last" if i == size - 1
        css << "item-#{i}"

        text, url, options = *item
        text = wrap_item(url, escape(text), options)
        tag(:li, text, :class => css.join(" "))
      end
    end
  end
end
