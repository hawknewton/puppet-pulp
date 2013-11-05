require 'spec_helper'
require 'classes/shared_consumer_packages'
require 'classes/shared_consumer_conf'

describe 'pulp::consumer' do
  let(:server) { 'server.myhost.com' }
  let(:facts) { { fqdn: server } }

  it { should_not be_nil }

  context 'with default parameters' do
    include_context :consumer_packages_present
    include_context :consumer_conf_present
    include_context :consumer_conf_default_template
  end

  context 'ensure => present' do
    let(:params) { { ensure: 'present' } }
    include_context :consumer_packages_present
    include_context :consumer_conf_present
    include_context :consumer_conf_default_template
  end

  context 'ensure => 2.2.0-1.el6' do
    let(:version) { '2.2.0-1.el6' }
    let(:params) { { ensure: version } }

    include_context :consumer_packages_pinned
    include_context :consumer_conf_present
    include_context :consumer_conf_default_template
  end

  context 'server => otherbox.myhost.com' do
    let(:params) { { server: 'otherbox.myhost.com' } }
    let(:server) { 'otherbox.myhost.com' }

    include_context :consumer_conf_default_template
  end

  context 'conf_template => test/consumer.conf.erb' do
    let(:params) { { conf_template: 'test/consumer.conf.erb' } }

    include_context :consumer_conf_test_template
  end

  context 'ensure => absent' do
    let(:params) { { ensure: 'absent' } }

    include_context :consumer_packages_absent
    include_context :consumer_conf_absent
  end
end
