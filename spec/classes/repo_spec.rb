require 'spec_helper'
require 'classes/shared_yumrepo'

describe 'pulp::repo' do
  context 'ensure => present' do
    let(:params) { { :ensure => 'present' } }

    include_context :yumrepo_present
  end

  context 'ensure => disabled' do
    let(:params) { { :ensure => 'disabled' } }

    include_context :yumrepo_disabled
  end

  context 'ensure => absent' do
    let(:params) { { :ensure => 'absent' } }

    include_context :yumrepo_absent
  end
end
