
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

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  require File.expand_path('../lib/dormouse/version', __FILE__)
  version = Dormouse::VERSION

  rdoc.rdoc_dir = 'doc'
  rdoc.title = "dormouse #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :load_version do
  require File.expand_path('../lib/dormouse/version', __FILE__)
end