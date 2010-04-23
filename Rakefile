
desc "build the dormouse"
task :build do
  sh "gem build dormouse.gemspec"
end

desc "install the dormouse"
task :install => [:load_version, :build] do
  sh "gem install dormouse-#{Dormouse::VERSION}.gem"
end

desc "release the dormouse"
task :release => [:load_version, :build] do
  unless %x[ git status 2>&1 ].include?('nothing to commit (working directory clean)')
    puts "Your git stage is not clean!"
    exit(1)
  end
  
  if %x[ git tag 2>&1 ].include?(Dormouse::VERSION)
    puts "Please bump your version first!"
    exit(1)
  end
  
  require File.expand_path('../lib/dormouse/version', __FILE__)
  sh "gem push dormouse-#{Dormouse::VERSION}.gem"
  sh "git tag -a -m \"#{Dormouse::VERSION}\" #{Dormouse::VERSION}"
  sh "git push origin master"
  sh "git push origin master --tags"
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = FileList['lib/**/*.rb'].to_a
    t.options = ['-m', 'markdown', '--files', FileList['documentation/*.markdown'].to_a.join(',')]
  end
rescue LoadError
  puts "YARD not available. Install it with: sudo gem install yard"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :load_version do
  require File.expand_path('../lib/dormouse/version', __FILE__)
end