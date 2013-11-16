require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet'


RSpec.configure do |c|
  c.mock_with :rspec

  c.before(:each) do
    Puppet::Util::Log.level = :warning
    Puppet::Util::Log.newdestination(:console)
  end
end

def fixture_path
  File.join File.dirname(__FILE__), 'fixtures'
end
