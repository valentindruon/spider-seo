require 'spider-seo/metadata/keyword'

module SpiderSeo
  class Document
    class Metadata

      # Initializer
      # param document is a Nokogiri::HTML::Document object
      def initialize doc
        self.document = doc
      end

      attr_accessor :document

      # Getter for title
      def meta_meta_title
        self.document.title
      end

      # Getter for encoding
      def meta_encoding
        self.document.meta_encoding
      end

      # Getter for meta keywords
      def meta_keywords
        xpath_meta_query('keywords')
      end

      # Getter for meta description
      def meta_description
        xpath_meta_query('description')
      end

      # Getter for meta google
      def meta_google
        xpath_meta_query('google')
      end

      # Getter for meta googlebot
      def meta_googlebot
        xpath_meta_query('googlebot')
      end

      # Getter for meta robots
      def meta_robots
        xpath_meta_query('robots')
      end

      # Getter for meta verify
      def meta_verify
        xpath_meta_query('verify')
      end

      # Getter for link tags
      # If rel is nil, return all <link> tags
      # Else, returns <link> tags with specified rel value
      # If options[:group] is set to true, will return a hash of array of SpiderSeo::Document::Tag
      def link(rel = [], options = {group: false})
        rel = Array(rel) unless rel.is_a? Array
        if options[:group]
          query = "//link[@rel = '%{value}']"
          return Hash[
            rel.map do |r|
              [r, SpiderSeo::Utils::xpath(self.document, query % {value: r})]
            end
          ]
        else
          rel_test = '['
          rel_test << rel.map{|r| "@rel = '#{r}'"}.join(' or ')
          rel_test << ']'
          query = "//link" + rel_test
          return SpiderSeo::Utils::xpath(self.document, query)
        end
      end

      # Getter for <link rel="canonical">
      # Just an alias for link('canonical')
      def canonical
        link('canonical')
      end

      # Getter for <link rel="alternate">
      # Just an alias for link('alternate')
      def alternate
        link('canonical')
      end

      # Getter for <link rel="stylesheet">
      # Just an alias for link('stylesheet')
      def stylesheet
        link('stylesheet')
      end

      # Getter for <link rel="prev"> and <link rel="next">
      def pagination options = {group: false}
        link(['prev', 'next'], group: options[:group])
      end

      # Returns a SpiderSeo::Document::Metadata::Keyword Array
      def keywords
        words = meta_keywords
        if words
          return words.split(',').map { |w| SpiderSeo::Document::Metadata::Keyword.new(w, self.document) }
        end
        return nil
      end

      # Getter for a specific meta tag
      # No cache for this method, Nokogiri::HTML::Document#xpath method is executed on each method call
      # param attr_name is meta attribute name (like name, http-equiv, property, ...)
      # param attr_value is meta attribute value (such as keywords, description, robots, ...)
      def meta(attr_value, attr_name = nil)
        return advanced_xpath_meta_query(attr_name, attr_value) if attr_name
        xpath_meta_query(attr_value)
      end

      # Getter for all meta tags that have name or http-equiv attribute
      # Returns a hash where
      # key = name|http-equiv meta tag attribute
      # value = content meta tag attribute
      def all
        self.document.xpath("//meta").map { |node| Hash[node.attribute_nodes.map { |att| [att.node_name, att.value] } ] }
      end

      private
        # self.document accessor

        # xPath query for metadata
        XPATH_META_QUERY = "//meta[translate(@%{attr_name},'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') ='%{attr_value}']/@content"

        # xPath query executor for meta tags
        # Will only look for tag that have name="#{name_or_http_equiv_value}" or http-equiv="#{name_or_http_equiv_value}"
        # Translate in xpath query is here to handle meta tags case (ex: name="keywords" or name="KEyWordS" etc...) and lower-case it
        def xpath_meta_query(name_or_http_equiv_value)
          (self.document.xpath(XPATH_META_QUERY % {attr_name: 'name', attr_value: name_or_http_equiv_value.downcase}).to_s ||
          self.document.xpath(XPATH_META_QUERY % {attr_name: 'http-equiv', attr_value: name_or_http_equiv_value.downcase})).to_s
        end

        # xPath advances query executor for meta tags
        # More precise than #xpath_meta_query, because you can pass attr_name which will enable looking for
        # tags such as <meta #{attr_name}="#{attr_value}"
        def advanced_xpath_meta_query(attr_name, attr_value)
          self.document.xpath(XPATH_META_QUERY % { attr_name: attr_name, attr_value: attr_value }).to_s
        end
    end
  end
end