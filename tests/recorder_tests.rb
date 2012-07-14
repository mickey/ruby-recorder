require 'recorder'

require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require 'minitest/unit'

class TestRecorder < MiniTest::Unit::TestCase
  def test_no_verbose
    Recorder.config do |c|
      c.verbose = false
    end
    
    assert_silent do
      Recorder.dump_to('test_verbose.yml') do
        [1, 2, 3]
      end
    end
  end

  def test_verbose
    Recorder.config do |c|
      c.verbose = false
    end
    
    assert_output do
      Recorder.dump_to('test_verbose.yml') do
        [1, 2, 3]
      end
    end
  end

  def test_directory
    assert_equal false, File.directory?('records')
    
    Recorder.config do |c|
      c.records_dir = 'records/'
    end

    Recorder.dump_to('test_directory.yml') do
      [1, 2, 3]
    end

    assert_equal true, File.exist?("records/test_directory.yml")
  end

  def test_no_stubb
    Recorder.config do |c|
      c.stubb = false
    end

    assert_output "TOTO\n" do
      Recorder.dump_to('test_no_stubb.yml') do
        -> {puts "TOTO"}.call
      end
    end

    assert_output "TOTO\n" do
      Recorder.dump_to('test_no_stubb.yml') do
        -> {puts "TOTO"}.call
      end
    end

    first_run = Recorder.dump_to('refactor.yml') do
      [{"username"=>"Michael Bensoussan"}]
    end

    second_run = Recorder.dump_to('refactor.yml') do
      [{"username"=>"Michael"}]
    end

    refute_equal first_run, second_run
  end

  def test_stubb
    Recorder.config do |c|
      c.stubb = true
    end

    assert_output "TOTO\n" do
      Recorder.dump_to('test_stubb.yml') do
        -> {puts "TOTO"}.call
      end
    end

    # this won't be call
    assert_silent do
      Recorder.dump_to('test_stubb.yml') do
        -> {puts "TOTO"}.call
      end
    end

    first_run = Recorder.dump_to('refactor.yml') do
      [{"username"=>"Michael Bensoussan"}]
    end

    second_run = Recorder.dump_to('refactor.yml') do
      [{"username"=>"Michael"}]
    end

    assert_equal first_run, second_run
  end
end

MiniTest::Unit.after_tests do
  files_to_clean = [
    "test_verbose.yml",
    "records/test_directory.yml",
    "test_no_stubb.yml",
    "test_stubb.yml",
    "refactor.yml"
  ]
  files_to_clean.each do |file|
    File.delete(File::expand_path("../../#{file}", __FILE__))
  end

  records_dir = File::expand_path("../../records", __FILE__)
  Dir.delete(records_dir) if File.directory?(records_dir)
end