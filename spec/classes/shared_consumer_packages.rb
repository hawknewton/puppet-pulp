require 'spec_helper'

shared_context :consumer_packages_present do
  it do
    should contain_package('pulp-agent').with_ensure 'present'
  end

  it do
    should contain_package('pulp-consumer-client').with_ensure 'present'
  end

  it do
    should contain_package('pulp-puppet-consumer-extensions').with_ensure 'present'
  end

  it do
    should contain_package('pulp-puppet-handlers').with_ensure 'present'
  end

  it do
    should contain_package('pulp-rpm-consumer-extensions').with_ensure 'present'
  end

  it do
    should contain_package('pulp-rpm-handlers').with_ensure 'present'
  end

  it do
    should contain_package('pulp-rpm-yumplugins').with_ensure 'present'
  end
end

shared_context :consumer_packages_pinned do
  it do
    should contain_package('pulp-agent').with_ensure version
  end

  it do
    should contain_package('pulp-consumer-client').with_ensure version
  end

  it do
    should contain_package('pulp-puppet-consumer-extensions').with_ensure version
  end

  it do
    should contain_package('pulp-puppet-handlers').with_ensure version
  end

  it do
    should contain_package('pulp-rpm-consumer-extensions').with_ensure version
  end

  it do
    should contain_package('pulp-rpm-handlers').with_ensure version
  end

  it do
    should contain_package('pulp-rpm-yumplugins').with_ensure version
  end
end

shared_context :consumer_packages_absent do
  it do
    should contain_package('pulp-agent').with_ensure 'absent'
  end

  it do
    should contain_package('pulp-consumer-client').with_ensure 'absent'
  end

  it do
    should contain_package('pulp-puppet-consumer-extensions').with_ensure 'absent'
  end

  it do
    should contain_package('pulp-puppet-handlers').with_ensure 'absent'
  end

  it do
    should contain_package('pulp-rpm-consumer-extensions').with_ensure 'absent'
  end

  it do
    should contain_package('pulp-rpm-handlers').with_ensure 'absent'
  end

  it do
    should contain_package('pulp-rpm-yumplugins').with_ensure 'absent'
  end
end
