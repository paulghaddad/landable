require 'action_view'

module Landable
  module Liquid

    class Tag < ::Liquid::Tag
      include ActionView::Helpers::TagHelper

      protected
      def lookup_page(context)
        context.registers.fetch(:page) do
          raise ArgumentError.new("`page' value was never registered with the template")
        end
      end
    end

    class TitleTag < Tag
      def render(context)
        page = lookup_page context
        content_tag(:title, page.title)
      end
    end

    class MetaTags < Tag
      def render(context)
        page = lookup_page context
        tags = page.meta_tags || {}

        tags.map { |name, value|
          tag(:meta, name: name, content: value)
        }.join("\n")
      end
    end

    class HeadContent < Tag
      def render(context)
        page = lookup_page context
        page.head_content
      end
    end

    class TemplateTag < Tag
      def initialize(tag, param, tokens)
        param_tokens = param.split(/\s+/)
        @template_slug = param_tokens.shift
        @variables = Hash[param_tokens.join(' ').scan(/([\w_]+):\s+"([^"]*)"/)]
      end

      def render(context)
        template = Landable::Template.find_by_slug @template_slug

        if template
          ::Liquid::Template.parse(template.body).render @variables
        else
          "<!-- render error: missing template \"#{@template_slug}\" -->"
        end
      end
    end

  end
end
