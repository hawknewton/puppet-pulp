require 'spec_helper'
require 'rspec/mocks'
require 'puppet-pulp/pulp_admin'

describe PuppetPulp::PuppetAdmin do
  let(:login) { 'test-login' }
  let(:password) { 'test-password' }

  let(:subject) { described_class.new login, password }

  describe '#login' do
    before { }

    it 'should login' do
      expect(subject).to receive(:`)
        .with('pulp-admin login -u test-login -p test-password')
        .and_return 'Successfully logged in.'
      subject.login
    end

    it 'should only login once' do
      expect(subject).to receive(:`)
        .with('pulp-admin login -u test-login -p test-password').once
        .and_return 'Successfully logged in.'
      subject.login
      subject.login
    end

    it 'should raise an error if login is unsuccessful' do
      expect(subject).to receive(:`)
        .with('pulp-admin login -u test-login -p test-password')
        .and_return 'Invalid Username or Password'

      expect { subject.login }.to raise_error /Invalid Username or Password/

    end
  end

  describe '#repos' do
    before do
      allow(subject).to receive(:`)
        .with('pulp-admin login -u test-login -p test-password')
        .and_return 'Successfully logged in.'

      allow(subject).to receive(:`)
        .with('pulp-admin puppet repo list --details')
        .and_return File.read("#{fixture_path}/repos.yml")
    end

    it 'should login' do
      expect(subject).to receive(:`)
        .with('pulp-admin login -u test-login -p test-password')
        .and_return 'Successfully logged in.'
      subject.repos
    end

    it 'should list repos' do
      expect(subject).to receive(:`)
        .with('pulp-admin puppet repo list --details')

      subject.repos
    end

    it 'should return a list of repos' do
      expect(subject.repos).to be_a Array
    end

    it 'should parse the repos' do
      repo = subject.repos[0]

      expect(repo.id).to eq 'balls'
      expect(repo.display_name).to eq 'balls display name'
      expect(repo.description).to eq 'balls description'
      expect(repo.notes['Name']).to eq 'value'
      expect(repo.feed).to eq "http://feed.com"
      expect(repo.queries).to eq ['query1', 'query2', 'query3']
      expect(repo.serve_http).to be_true
      expect(repo.serve_https).to be_true
    end

    it 'should return nil description when Description is \'None\'' do
      expect(subject.repos[1].description).to be_nil
    end

    it 'should return an empty hash when there are no notes' do
      expect(subject.repos[1].notes).to be_a Hash
      expect(subject.repos[1].notes).to be_empty
    end

    it 'should default serve_http to true' do
      expect(subject.repos[1].serve_http).to be_true
    end

    it 'should default serve_https to false' do
      expect(subject.repos[1].serve_https).to equal false
    end

    it 'should default queries to an empty list' do
      expect(subject.repos[1].queries).to be_a Array
      expect(subject.repos[1].queries).to be_empty
    end
  end

end
