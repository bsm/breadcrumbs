require "jeweler"
require "rake/testtask"
require "rake/rdoctask"
require "lib/breadcrumbs/version"

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = "doc"
  rdoc.title = "Breadcrumbs"
  rdoc.options += %w[ --line-numbers --inline-source --charset utf-8 ]
  rdoc.rdoc_files.include("README.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "bsm-breadcrumbs"
    gem.email = "dimitrij@blacksquaremedia.com"
    gem.homepage = "http://github.com/bsm/breadcrumbs"
    gem.authors = ["Nando Vieira", "Dimitrij Denissenko"]
    gem.version = Breadcrumbs::Version::STRING
    gem.summary = "Breadcrumbs is a simple plugin that adds a `breadcrumbs` object to controllers and views."
    gem.description = "Breadcrumbs is a simple plugin that adds a `breadcrumbs` object to controllers and views."
    gem.add_runtime_dependency "actionpack", ">= 3.0.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
