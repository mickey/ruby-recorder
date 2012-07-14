#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => [:test]

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "tests/*_tests.rb"
end