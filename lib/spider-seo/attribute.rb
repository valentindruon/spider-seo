module SpiderSeo
  class Document
    class Attribute
      attr_accessor :name
      attr_accessor :value

      def to_s
        "#{self.name} => #{self.value}"
      end
    end
  end
end