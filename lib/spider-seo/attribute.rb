module SpiderSeo
  class Document
    class Attribute
      attr_accessor :name
      attr_accessor :value

      def initialize(name, value)
        self.name = name
        self.value = value
      end

      def to_s
        "#{self.name} => #{self.value}"
      end
    end
  end
end