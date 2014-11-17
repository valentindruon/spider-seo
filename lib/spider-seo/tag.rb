module SpiderSeo
  class Document
    class Tag
      attr_accessor :name
      attr_accessor :text
      attr_accessor :attributes

      # Constructor
      def initialize name = nil, text = nil, attributes = []
        self.name = nil
        self.text = text
        self.attributes = attributes
      end
    end
  end
end