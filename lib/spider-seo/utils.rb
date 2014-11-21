require 'spider-seo/tag'
require 'spider-seo/attribute'

module SpiderSeo
  module Utils
      # Get children of an element, an cast them into a SpiderSeo::Document::Tag object
      def self.children(element)
        element.children.map do |child|
          SpiderSeo::Document::Tag.new(
            child.name,
            child.text,
            attributes(child),
            children(child)
          )
        end
      end

      # Get attributes of an element, and cast them into a SpiderSeo::Document::Attribute array
      def self.attributes(element)
        element.attribute_nodes.map do |att|
          SpiderSeo::Document::Attribute.new(att.node_name, att.value)
        end
      end

      # Query SpiderSeo::Document object with an XPath query
      # document param : document to query
      # query : XPath query to run
      # Returns a SpiderSeo::Document::Tag array
      def self.xpath(document, query)
        document.xpath(query).map do |node|
          SpiderSeo::Document::Tag.new(
            node.name,
            node.text,
            SpiderSeo::Utils::attributes(node),
            SpiderSeo::Utils::children(node)
          )
        end
      end
  end
end