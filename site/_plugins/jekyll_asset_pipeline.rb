require 'jekyll_asset_pipeline'

module JekyllAssetPipeline
  
  class LessConverter < JekyllAssetPipeline::Converter
    require 'less'

    def self.filetype
      '.less'
    end

    def convert
      parser = Less::Parser.new
      return parser.parse(@content).to_css(:compress => true)
    end
  end

  class JavaScriptCompressor < JekyllAssetPipeline::Compressor
    require 'uglifier'

    def self.filetype
      '.js'
    end

    def compress
      return Uglifier.compile(@content)
    end
  end
end