require 'thor'
require 'rsmp_schema'
require 'pp'

module RSMP::Schema
  class CLI < Thor
    desc "convert", "Convert SXL from YAML to JSON Schema"
    method_option :in, :type => :string, :aliases => "-i", banner: 'Path to YAML input file'
    method_option :out, :type => :string, :aliases => "-o", banner: 'Path to JSON Schema output file'
    def convert
      unless options[:in]
        puts "Error: Input option missing"
        exit
      end

      unless options[:out]
        puts "Error: Output option missing"
        exit
      end

      unless File.exist? options[:in]
        puts "Error: Input path file #{options[:in]} not found"
        exit
      end

      extension = File.extname options[:in]
      case extension
      when '.yaml', '.yml'
        sxl = RSMP::Convert::Import::YAML.read options[:in]
      else
        raise RuntimeError.new "Unknown input file format #{extension}"
      end

      #pp sxl

      #RSMP::Convert::Export::JSONSchema.write sxl, options[:out]
    end

    desc "compare", "Compare RST to YAML"
    method_option :in, :type => :string, :aliases => "-i", banner: 'Path to YAML input file'
    method_option :target, :type => :string, :aliases => "-t", banner: 'Path to RST file to compare to'
    def compare
      unless options[:in]
        puts "Error: Input option missing"
        exit
      end

      unless options[:target]
        puts "Error: Target option missing"
        exit
      end

      unless File.exist? options[:in]
        puts "Error: Input path file #{options[:in]} not found"
        exit
      end

      unless File.exist? options[:target]
        puts "Error: Target path file #{options[:target]} not found"
        exit
      end

      sxl = RSMP::Convert::Import::YAML.read options[:in]
      pp sxl
      target = RSMP::Convert::Import::RST.read options[:target]
    end

    # avoid Thor returnin 0 on failures, see
    # https://github.com/coinbase/salus/pull/380/files
    def self.exit_on_failure?
      true
    end
  end

end