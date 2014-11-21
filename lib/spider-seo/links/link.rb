require 'spider-seo/tag'

module SpiderSeo
  class Document
    class Links
      class Link < SpiderSeo::Document::Tag

        attr_accessor :href

        # Constructor
        def initialize(name = nil, href = nil, text = nil, attributes = [])
          self.name = name
          self.href = href
          self.text = text
          self.attributes = attributes
        end

        # Determines if self is a link with rel="nofollow" attribute
        def is_no_follow?
          !self.attributes.select {|att| att.name == 'rel' and att.value == 'nofollow'}.first.nil?
        end

        # Determines if self.href is an internal link, compared to param uri
        def internal?(uri)
          self.href.empty? || self.anchor? || self.relative? || self.begins_with_slash? || self.not_a_link? || self.same_host?(uri)
        end

        # Determines if self.href in an anchor
        def anchor?
          self.href[0,1] == '#'
        end

        # Determines if self.href is a relative path
        def relative?
          require 'uri'
          URI(self.href).relative?
        end

        # Determines if self.href begins with a slash
        def begins_with_slash?
          self.href[0,1] == '/'
        end

        # Determines if self.href is not a link (such as javascript:void or mailto)
        def not_a_link?
          !(self.href =~ /^javascript:/).nil? || !(self.href =~ /^mailto:/).nil?
        end

        # Determines if self.href has the same host than param uri
        def same_host? uri
          return false if uri.nil?
          require 'uri'
          uri1 = URI(self.href.downcase.gsub(/www./, '')).host
          uri2 = URI(uri.downcase.gsub(/www./, '')).host
          uri1 == uri2
        end
      end
    end
  end
end