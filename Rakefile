# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'
require 'rspec/core/rake_task'
require 'cover_me'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

CoverMe.config do |c|
  c.project.set_default(:root, Configatron::Delayed.new{Dir.pwd})
  c.set_default(:file_pattern, Configatron::Delayed.new do
    /#{CoverMe.config.project.root}\/lib\/.+\.rb)/ix
  end)
end