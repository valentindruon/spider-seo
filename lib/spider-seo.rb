require "spider-seo/version"
require 'nokogiri'
require 'spider-seo/tag'
require 'spider-seo/attribute'
require 'spider-seo/metadata'
require 'spider-seo/links'
require 'spider-seo/microdata'
require 'spider-seo/utils'

module SpiderSeo
  class Document
    # Contains Nokogiri::HTML::Document object
    attr_accessor :document
    attr_accessor :metadata
    attr_accessor :links
    attr_accessor :microdata

    # Initializer
    # uri_or_html is either an URI or a HTML string
    # options is options to pass to open-uri#open
    def initialize uri_or_html = nil, options = {}
      if uri_or_html
        require 'uri'
        if uri_or_html =~ /\A#{URI::regexp}\z/ # Use URI::regexp to check if uri_or_html is an uri
          self.document = from_uri uri_or_html
        elsif uri_or_html =~ /^s*<[^Hh>]*html/ # Use regexp to check if uri_or_html is a HTML string
          self.document = from_html uri_or_html, options
        else
          raise "The string you provided is neither an URI nor a HTML string."
        end
        self.metadata = SpiderSeo::Document::Metadata.new(self.document)
        self.links = SpiderSeo::Document::Links.new(self.document)
        self.microdata = SpiderSeo::Document::Microdata.new(self.document)
      end
      return self
    end

    # Returns a Nokogiri::HTML::Document
    # From a HTML string
    def from_html html
      self.document = Nokogiri::HTML(html)
    end

    # Returns a Nokogiri::HTML::Document
    # From an uri
    # options are options available for open_uri#open
    def from_uri uri, options = {}
      require 'open-uri'
      self.document = Nokogiri::HTML(open(uri, options))
    end

    # Get specific tags
    # Parameter @tag is the tag name
    # Option method is either :list or :count
    # :list will return SpiderSeo::Document::Tag array
    # :count will return the number of tag in document
    def tag(name, options = {method: :list})
      query = "//#{name}"
      return SpiderSeo::Utils::xpath(self.document, query) if options[:method] == :list
      return SpiderSeo::Utils::xpath(self.document, query).size if options[:method] == :count
    end

    # Get h1 tags
    # Option method is either :list or :count
    # :list will return SpiderSeo::Document::Tag array
    # :count will return the number of tag in document
    # Just an alias for #tag
    def h1(options = {method: :list})
      tag('h1', method: options[:method])
    end

    # Get h2 tags
    # Option method is either :list or :count
    # :list will return SpiderSeo::Document::Tag array
    # :count will return the number of tag in document
    # Just an alias for #tag
    def h2(options = {method: :list})
      tag('h2', method: options[:method])
    end

    # Get p tags
    # Option method is either :list or :count
    # :list will return SpiderSeo::Document::Tag array
    # :count will return the number of tag in document
    # Just an alias for #tag
    def p(options = {method: :list})
      tag('p', method: options[:method])
    end
  end
end
