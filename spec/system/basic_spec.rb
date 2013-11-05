require 'spec_helper_system'

describe 'pulp class:' do
  context puppet_agent do
    its(:stderr) { should be_empty }
    its(:exit_code) { should_not == 1 }
  end

  pp = "class { 'pulp': }"

  context puppet_apply pp do
    its(:stderr) { should be_empty }
    its(:exit_code) { should_not == 1 }
    its(:refresh) { should be_nil }
    its(:stderr) { should be_empty }
    its(:exit_code) { should be_zero }

    context puppet_apply pp do
      its(:exit_code) { should == 0 }
    end
  end

  conf = File.read File.join fixture_path, 'server.conf'
  conf = conf.gsub '"', '\\"'

  pp = %Q{
class { 'pulp::server': }
class { 'pulp': }
}

  context puppet_apply pp do
    its(:stderr) { should be_empty }
    its(:exit_code) { should_not == 1 }
    its(:refresh) { should be_nil }
    its(:stderr) { should be_empty }
    its(:exit_code) { should be_zero }

    context puppet_apply pp do
      its(:exit_code) { should == 0 }
    end
  end
end
