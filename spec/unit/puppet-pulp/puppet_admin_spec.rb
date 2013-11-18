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

      before do
        allow(subject).to receive(:`).
          with("pulp-admin puppet repo create --repo-id=\"#{repo_id}\"").
          and_return "Successfully created repository [#{repo_id}]"

        allow(subject).to receive(:`).
          with('pulp-admin login -u test-login -p test-password').
          and_return 'Successfully logged in.'
      end

      it 'should login' do
        expect(subject).to receive(:`).
          with('pulp-admin login -u test-login -p test-password').
          and_return 'Successfully logged in.'
        subject.create repo_id
      end

      it 'should create the repository' do
        expect(subject).to receive(:`).
          with("pulp-admin puppet repo create --repo-id=\"#{repo_id}\"").
          and_return "Successfully created repository [#{repo_id}]"

        subject.create repo_id
      end

      context 'when repository creation fails' do
        before do
          allow(subject).to receive(:`).
            with("pulp-admin puppet repo create --repo-id=\"#{repo_id}\"").
            and_return "Stuff did not happen"
        end

        it 'should raise an exception' do
          expect { subject.create repo_id }.
            to raise_error /Stuff did not happen/
        end
      end

      context 'with params' do
        let(:display_name) { 'new repo display name' }
        let(:description) { 'description' }
        let(:queries) { ['query1', 'query2' ] }
        let(:notes) { { 'name1' => 'value1', 'name2' => 'value2' } }

        it 'should params to puppet-admin' do
          expect(subject).to receive(:`).
            with("pulp-admin puppet repo create --repo-id=\"#{repo_id}\" --display-name=\"#{display_name}\" --description=\"#{description}\" --serve-http=\"true\" --serve-https=\"false\" --queries=query1,query2 --notes \"name2=value2\" --notes \"name1=value1\"").
            and_return "Successfully created repository [#{repo_id}]"

          subject.create repo_id, {
            :display_name => display_name,
            :description => description,
            :serve_http => 'true',
            :serve_https => 'false',
            :queries => queries,
            :notes => notes
          }
        end
      end
    end
  end

  describe '#destroy' do
    context 'with a repo id' do
      let(:repo_id) { 'new_repo' }
      before do
        allow(subject).to receive(:`).
          with("pulp-admin puppet repo delete --repo-id=\"#{repo_id}\"").
          and_return "Repository [#{repo_id}] successfully deleted"

        allow(subject).to receive(:`).
          with('pulp-admin login -u test-login -p test-password').
          and_return 'Successfully logged in.'
      end

      it 'should login' do
        expect(subject).to receive(:`).
          with('pulp-admin login -u test-login -p test-password').
          and_return 'Successfully logged in.'

        subject.destroy repo_id
      end

      it 'should delete the specified repo' do
        expect(subject).to receive(:`).
          with("pulp-admin puppet repo delete --repo-id=\"#{repo_id}\"").
          and_return "Repository [#{repo_id}] successfully deleted"
        subject.destroy repo_id
      end

      context 'when repository removal fails' do
        it 'should raise an error' do
          expect(subject).to receive(:`).
            with("pulp-admin puppet repo delete --repo-id=\"#{repo_id}\"").
            and_return "Couldn't delete repo"

          expect { subject.destroy repo_id }.to raise_error
        end
      end
    end
  end

  describe '#login' do
    let(:subject) { described_class.new 'other-login', 'other-password' }

    it 'should login' do
      expect(subject).to receive(:`).
        with('pulp-admin login -u other-login -p other-password').
        and_return 'Successfully logged in.'
      subject.login
    end

    it 'should only login once' do
      expect(subject).to receive(:`).
        with('pulp-admin login -u other-login -p other-password').once.
        and_return 'Successfully logged in.'
      subject.login
      subject.login
    end

    it 'should raise an error if login is unsuccessful' do
      expect(subject).to receive(:`).
        with('pulp-admin login -u other-login -p other-password').
        and_return 'Invalid Username or Password'

      expect { subject.login }.to raise_error /Invalid Username or Password/

    end
  end

  describe '#repos' do
    before do
      allow(subject).to receive(:`).
        with('pulp-admin login -u test-login -p test-password').
        and_return 'Successfully logged in.'
    end

    context 'with no repos defined' do
      before do
        allow(subject).to receive(:`).
          with('pulp-admin puppet repo list --details').
          and_return File.read("#{fixture_path}/puppet_empty.txt")
      end

      it 'should return an empty list' do
        expect(subject.repos).to be_empty
      end
    end

    context 'with repos defined' do
      before do
        allow(subject).to receive(:`).
          with('pulp-admin puppet repo list --details').
          and_return File.read("#{fixture_path}/puppet_repos.txt")
      end

      it 'should login' do
        expect(subject).to receive(:`).
          with('pulp-admin login -u test-login -p test-password').
          and_return 'Successfully logged in.'
        subject.repos
      end

      it 'should list repos' do
        expect(subject).to receive(:`).
          with('pulp-admin puppet repo list --details')

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
          expect(subject).to receive(:`).
            with 'pulp-admin puppet repo update --repo-id=balls --display-name="awesome name"'

          subject.repos['balls'].display_name = 'awesome name'
        end
      end

      describe '#description=' do
        it 'should call pulp-admint o set the description' do
          expect(subject).to receive(:`).
            with 'pulp-admin puppet repo update --repo-id=balls --description="awesome description"'

          subject.repos['balls'].description = 'awesome description'
        end
      end

      describe '#serve_http=' do
        it 'should call pulp-admin o set serve_http' do
          expect(subject).to receive(:`).
            with 'pulp-admin puppet repo update --repo-id=balls --serve-http="false"'

          subject.repos['balls'].serve_http = false
        end
      end

      describe '#serve_https=' do
        it 'should call pulp-admin to set serve_https' do
          expect(subject).to receive(:`).
            with 'pulp-admin puppet repo update --repo-id=balls --serve-https="false"'

          subject.repos['balls'].serve_https = false
        end
      end

      describe '#serve_queries=' do
        it 'should call pulp-admin to set notes' do
          expect(subject).to receive(:`).
            with 'pulp-admin puppet repo update --repo-id=balls --notes "name2=value2" --notes "name1=value1"'
          subject.repos['balls'].notes = {
            'name1' => 'value1',
            'name2' => 'value2'
          }
        end

        it 'should pass an an empty value' do
          expect(subject).to receive(:`).
            with 'pulp-admin puppet repo update --repo-id=balls --notes "name1="'
          subject.repos['balls'].notes = {
            'name1' => ''
          }
        end

        context 'when notes map is empty' do
          it 'should not update repo' do
            expect(subject).to_not receive(:`).with do |arg|
              arg =~ /puppet-admin repo update/
            end
            subject.repos['balls'].queries = []
          end
        end
      end

      describe '#notes=' do
        it 'should call pulp-admin to set queries' do
          expect(subject).to receive(:`).
            with 'pulp-admin puppet repo update --repo-id=balls --queries="query5,query6,query7"'
          subject.repos['balls'].queries = ['query5', 'query6', 'query7']
        end

        context 'when queries array is empty' do
          it 'should call --queries with an empty string' do
            expect(subject).to receive(:`).
              with 'pulp-admin puppet repo update --repo-id=balls --queries=""'
            subject.repos['balls'].queries = []
          end
        end
      end
    end
  end
end
