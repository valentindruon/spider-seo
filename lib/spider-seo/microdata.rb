require 'spider-seo/tag'

module SpiderSeo
  class Document
    class Microdata

      # Constructor
      def initialize doc
        self.document = doc
      end

      attr_accessor :document

      # Get all elements that have itemprop as an attribute
      def list
        self.document.xpath("//*[@itemprop]").map do |node|
          SpiderSeo::Document::Tag.new(
            node.name,
            node.text,
            node.map { |att| SpiderSeo::Document::Attribute.new(att.node_name, att.value) },
            SpiderSeo::Utils::children(node)
          )
        end
      end

      # Get all elements that have itemscope attribute and fill their children with itemprop descendants
      def list_with_descendants
        self.document.xpath("//*[@itemprop]").map do |node|
          SpiderSeo::Document::Tag.new(
            node.name,
            node.text,
            node.map { |att| SpiderSeo::Document::Attribute.new(att.node_name, att.value) },
            SpiderSeo::Utils::children(node)
          )
        end
      end

      private

        # Get a node's descendants that have itemprop attribute
        def descendants(node)
          node.children.select{ |child| child.attribute('itemprop') }.map do |child|
            SpiderSeo::Document::Tag.new(
              child.name,
              child.text,
              child.map { |att| SpiderSeo::Document::Attribute.new(att.node_name, att.value) }
            )
          end
        end
    end
  end
end