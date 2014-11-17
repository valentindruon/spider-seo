require 'spider-seo/tag'
require 'spider-seo/attribute'

module SpiderSeo
  module Utils
      # Get children of an element, an cast them as a SpiderSeo::Document::Tag object
      def children(element)
        element.children.map do |child|
          SpiderSeo::Document::Tag.new(
            child.name,
            child.text,
            child.attribute_nodes.map { |att| SpiderSeo::Document::Attribute.new(att.node_name, att.value) },
            children(child)
          )
        end
      end
  end
end