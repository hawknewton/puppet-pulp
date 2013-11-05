require 'spec_helper_system'

describe puppet_manifest('class { "pulp": }') do
  it { should be_idempotent }
  its(:exit_code) { should_not == 1 }
  its(:stderr) { should be_empty }
  its(:refresh) { should be_nil }
end
