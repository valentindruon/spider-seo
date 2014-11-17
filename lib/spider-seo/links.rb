require 'spider-seo/links/link'

module SpiderSeo
  class Document
    class Links

      # Initializer
      # param document is a Nokogiri::HTML::Document object
      def initialize doc
        self.document = doc
      end

      attr_accessor :document

      # Get all document's <a> tags
      def all
        links = self.document.css('a')
        return links.map {|node| SpiderSeo::Document::Links::Link.new(node['href'], node.text, Hash[node.attribute_nodes.map { |att| [att.node_name, att.value] }]) }
      end
    end
  end
end