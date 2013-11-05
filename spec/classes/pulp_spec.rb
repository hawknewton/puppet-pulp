require 'spec_helper'
require 'classes/shared_pulp_repo_class'

describe 'pulp' do
  it { should create_class 'pulp' }

  context 'default ensure parameter' do
    include_context :pulp_repo_class_enabled
  end

  context 'ensure => enabled' do
    let(:params) { { ensure: 'enabled' } }

    include_context :pulp_repo_class_enabled
  end

  context 'ensure => disabled' do
    let(:params) { { ensure: 'disabled' } }

    include_context :pulp_repo_class_disabled
  end

  context 'ensure => absent' do
    let(:params) { { ensure: 'absent' } }

    include_context :pulp_repo_class_absent
  end
end
