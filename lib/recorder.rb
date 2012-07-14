require "recorder/version"
require 'yaml'
require 'differ'
require 'colored'

module Recorder
  Config = Struct.new(:records_dir, :verbose, :stubb)
  @@config = Config.new

  class << self
    attr_reader :config

    # Configure Recorder
    #
    # ==== Examples
    #   Recorder.config do |c|
    #     c.verbose = true
    #     c.stubb = true
    #     c.records_dir = 'records/'
    #   end
    def config(&block)
      block_given? ? @@config.tap(&block) : @@config
    end

    def dump_to file
      if @@config.records_dir
        Dir.mkdir @@config.records_dir unless File.directory? @@config.records_dir
        file = File.join(@@config.records_dir, file)
      end

      if !@@config.stubb
        result = yield
        yaml_result = result.to_yaml
        if File.exist? file
          old_result = YAML.load_file(file)
          if old_result != yaml_result
            outputs "Recorder: result is different from last run".red
            Differ.format = :color
            outputs Differ.diff_by_line(yaml_result.to_s, old_result.to_s)
          else
            outputs "Recorder: result is the same".green
          end
        else
          File.open(file, 'w' ) do |out|
            YAML.dump(yaml_result, out)
          end
          outputs "Recorder: recorded in #{file}".green
        end
        return result
      else
        if File.exist? file
          outputs "Recorder: loaded from #{file}".green
          return YAML.load_file(file)
        else
          result = yield
          yaml_result = result.to_yaml
          File.open(file, 'w' ) do |out|
            YAML.dump(yaml_result, out)
          end
          outputs "Recorder: recorded in #{file}".green
          return result
        end
      end
    end

    private
      def outputs msg
        puts msg if @@config.verbose
      end
  end
end