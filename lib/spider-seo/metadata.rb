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
      def title
        self.document.title
      end

      # Getter for encoding
      def encoding
        self.document.meta_encoding
      end

      # Getter for meta keywords
      def keywords options = {}
        xpath_meta_query('keywords')
      end

      # Getter for meta description
      def description
        xpath_meta_query('description')
      end

      # Getter for meta google
      def google
        xpath_meta_query('google')
      end

      # Getter for meta googlebot
      def googlebot
        xpath_meta_query('googlebot')
      end

      # Getter for meta robots
      def robots
        xpath_meta_query('robots')
      end

      # Getter for meta verify
      def verify
        xpath_meta_query('verify')
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
          (self.document.xpath(XPATH_META_QUERY % {attr_name: 'name', attr_value: name_or_http_equiv_value.downcase}) ||
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