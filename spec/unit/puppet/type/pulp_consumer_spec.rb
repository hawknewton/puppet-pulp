require 'spec_helper'

type = Puppet::Type.type(:pulp_consumer)

describe type do
  subject { type.new({:name => name, :login => login, :password => password}.merge params) }
  let(:params) { { } }

  context 'given an invalid id' do
    let(:name) { 'invalid name' }
    let(:login) { 'test_login' }
    let(:password) { 'test_password' }

    example do
      expect { subject }.to raise_error Puppet::Error, /id may contain only/
    end
  end

  context 'given no login' do
    let(:name) { 'valid_name' }
    let(:login) { '' }
    let(:password) { 'test_password' }

    example do
      expect { subject }.to raise_error Puppet::Error, /must specify login/
    end
  end

  context 'given no password' do
    let(:name) { 'valid_name' }
    let(:login) { 'test_login' }
    let(:password) { '' }

    example do
      expect { subject }.to raise_error Puppet::Error, /must specify password/
    end
  end

  context 'given a valid consumer id, login, and password' do
    let(:name) { 'valid_consumer' }
    let(:login) { 'test_login' }
    let(:password) { 'test_password' }

    example do
      expect { subject }.to_not raise_error
    end
  end
end
