require 'spec_helper'
require 'rspec/mocks'
require 'puppet-pulp/pulp_admin'

describe PuppetPulp::PulpAdmin do
  let(:login) { 'test-login' }
  let(:password) { 'test-password' }

  let(:subject) { described_class.new login, password }

  describe '#create' do
    context 'with a repo id' do
      let(:repo_id) { 'new_repo' }
      context 'and display name' do
        let(:display_name) { 'new repo display name' }

        before do
          allow(subject).to receive(:`)
            .with("pulp-admin puppet repo create --repo-id=\"#{repo_id}\" --display-name=\"#{display_name}\"")
            .and_return "Successfully created repository [#{repo_id}]"

          allow(subject).to receive(:`)
            .with('pulp-admin login -u test-login -p test-password')
            .and_return 'Successfully logged in.'
        end

        it 'should login' do
          expect(subject).to receive(:`)
            .with('pulp-admin login -u test-login -p test-password')
            .and_return 'Successfully logged in.'
          subject.create repo_id, { display_name: display_name }
        end

        it 'should create the repository' do
          expect(subject).to receive(:`)
            .with("pulp-admin puppet repo create --repo-id=\"#{repo_id}\" --display-name=\"#{display_name}\"")
            .and_return "Successfully created repository [#{repo_id}]"

          subject.create repo_id, { display_name: display_name }
        end

        context 'when repository creation fails' do
          before do
            allow(subject).to receive(:`)
              .with("pulp-admin puppet repo create --repo-id=\"#{repo_id}\" --display-name=\"#{display_name}\"")
              .and_return "Stuff did not happen"
          end

          it 'should raise an exception' do
            expect { subject.create repo_id, { display_name: display_name } }
              .to raise_error /Stuff did not happen/
          end
        end
      end
    end
  end

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
    end

    context 'with no repos defined' do
      before do
        allow(subject).to receive(:`)
          .with('pulp-admin puppet repo list --details')
          .and_return File.read("#{fixture_path}/puppet_empty.txt")
      end

      it 'should return an empty list' do
        expect(subject.repos).to be_empty
      end
    end

    context 'with repos defined' do
      before do
        allow(subject).to receive(:`)
          .with('pulp-admin puppet repo list --details')
          .and_return File.read("#{fixture_path}/puppet_repos.txt")
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

      it 'should return a map of repos' do
        expect(subject.repos).to be_a Hash
      end

      it 'should parse the repos' do
        repo = subject.repos['balls']

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
        expect(subject.repos['balls2'].description).to be_nil
      end

      it 'should return an empty hash when there are no notes' do
        expect(subject.repos['balls2'].notes).to be_a Hash
        expect(subject.repos['balls2'].notes).to be_empty
      end

      it 'should default serve_http to true' do
        expect(subject.repos['balls2'].serve_http).to be_true
      end

      it 'should default serve_https to false' do
        expect(subject.repos['balls2'].serve_https).to equal false
      end

      it 'should default queries to an empty list' do
        expect(subject.repos['balls2'].queries).to be_a Array
        expect(subject.repos['balls2'].queries).to be_empty
      end

      describe '#display_name=' do
        it 'should call pulp-admin to set the display name' do
          expect(subject).to receive(:`)
            .with 'pulp-admin puppet repo update --repo-id=balls --display-name="awesome name"'

          subject.repos['balls'].display_name = 'awesome name'
        end
      end
    end
  end
end
