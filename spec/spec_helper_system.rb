require 'rspec-system/spec_helper'
require 'rspec-system-puppet/helpers'

include RSpecSystemPuppet::Helpers

RSpec.configure do |c|
  # Project root for the this module's code
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Enable colour in Jenkins
  c.tty = true

  c.include RSpecSystemPuppet::Helpers

  # This is where we 'setup' the nodes before running our tests
  c.before :suite do
    # Install puppet
    puppet_install
    puppet_master_install

    shell 'rm -rf /etc/puppet/modules/*'

    puppet_module_install(:source => proj_root, :module_name => 'pulp')
    shell 'puppet module install stahnma/epel -v 0.0.5'
    puppet_apply 'include epel'
  end
end

class PuppetManifest
  def initialize(code)
    @code = code
  end

  def exit_code
    run.exit_code
  end

  def stderr
    run.stderr
  end

  def refresh
    run.refresh
  end

  def run
    @run = puppet_apply @code if @run.nil?
    @run
  end

  def idempotent?
    run
    puppet_apply(@code).exit_code == 0
  end

  def to_s
    "\"#{@code}\""
  end
end

def puppet_manifest(code)
  PuppetManifest.new code
end

