require "bundler/gem_tasks"
require "rake/testtask"
project_name = "source2epub"

Rake::TestTask.new do |t|
  t.libs << "lib/#{project_name}"
  t.test_files = FileList["test/lib/#{project_name}/test_*.rb"]
  t.verbose = true
end

task default: [:test, :rubocop]
task :pry do
  require "pry"
  require "awesome_print"
  require_relative "lib/source2epub"
  include Source2Epub
  ARGV.clear
  Pry.start
end

require "rubocop/rake_task"
desc "Run RuboCop on the lib directory"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ["lib/**/*.rb"]
  task.formatters = ["files"]
  task.fail_on_error = false
end
