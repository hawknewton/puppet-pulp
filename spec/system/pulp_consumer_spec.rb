require 'spec_helper_system'

manifest = %q{
  class { 'pulp': }
  class { 'pulp::consumer': }
}

describe puppet_manifest(manifest) do
  it { should be_idempotent }
  its(:exit_code) { should_not == 1 }
  its(:stderr) { should be_empty }
  its(:refresh) { should be_nil }
end
