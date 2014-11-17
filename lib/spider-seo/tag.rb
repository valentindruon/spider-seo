module SpiderSeo
  class Document
    class Tag
      attr_accessor :name
      attr_accessor :attributes

      # Constructor
      def initialize name = nil, attributes = []
        self.name = nil
        self.attributes = attributes
      end
    end
  end
end