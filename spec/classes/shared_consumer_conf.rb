require 'spec_helper'

shared_context :consumer_conf_present do
  it do
    should contain_file('/etc/pulp/consumer/consumer.conf').with({
      :ensure  => 'present',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '644',
      :require => 'Package[pulp-consumer-client]'
    })
  end
end


shared_context :consumer_conf_absent do
  it do
    should contain_file('/etc/pulp/consumer/consumer.conf').with_ensure 'absent'
  end
end

shared_context :consumer_conf_default_template do
  it do
    should contain_file('/etc/pulp/consumer/consumer.conf').with_content /#{server}/
  end
end

shared_context :consumer_conf_test_template do
  it do
    should contain_file('/etc/pulp/consumer/consumer.conf').with_content /This is a test template/
  end
end
