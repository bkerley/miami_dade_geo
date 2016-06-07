require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'

RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new(:doc) do |yard|
  yard.options = ["--markup-provider kramdown",
                  "--markup markdown"
                 ].map{|e| e.split(' ')}.flatten
end

task :default => :spec
