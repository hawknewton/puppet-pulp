require 'spec_helper'

shared_context :consumer_services_running do
  it do
    should contain_service('pulp-agent').with({
      :ensure => 'running',
      :require => 'Package[pulp-agent]'
    })
  end
end

shared_context :consumer_services_stopped do
  it do
    should contain_service('pulp-agent').with({
      :ensure => 'stopped',
      :before => 'Package[pulp-agent]'
    })
  end
end
