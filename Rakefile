require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'rspec-system/rake_task'

#Guard calls spec_prep, but not spec_clean
task :spec_system => :spec_clean_if_needed

task :spec_clean_if_needed do
  pulp = File.join 'spec', 'fixtures', 'modules', 'pulp'
  Rake::Task['spec_clean'].invoke if File.exists? pulp
end
