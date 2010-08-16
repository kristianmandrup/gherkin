require 'gherkin/i18n'
require 'gherkin/native'

module Gherkin
  module Lexer
    I18nLexerNotFound = Class.new(LoadError)
    LexingError = Class.new(StandardError)

    # The main entry point to lexing Gherkin source.
    class I18nLexer
      native_impl('gherkin')

      LANGUAGE_PATTERN = /^\s*#\s*language\s*:\s*([a-zA-Z\-]+)/ #:nodoc:
      attr_reader :i18n_language

      def initialize(listener, force_ruby=false)
        @listener = listener
        @force_ruby = force_ruby
      end

      def scan(source)
        puts "source: #{source}"
        _delegate = create_delegate(source)
        puts "delegate: #{_delegate}"
        _delegate.scan(source)
      end

    private

      def create_delegate(source)
        @i18n_language = lang(source)
        @i18n_language.lexer(@listener, @force_ruby)
      end

      def lang(source)
        line_one = source.split(/\n/)[0]
        match = LANGUAGE_PATTERN.match(line_one)
        I18n.get(match ? match[1] : 'en')
      end

    end
  end
end
