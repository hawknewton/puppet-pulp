require 'spec_helper'
type = Puppet::Type.type :puppet_repo
provider_class = type.provider :pulp_admin

puts provider_class.inspect

describe provider_class do
  subject { provider_class.new(type.new(default_params.merge params)) }

  let(:default_params) do
    { :id => repo_id,
      :login => 'test-login',
      :password => 'test-password' }
  end

  let(:repo_id) { 'test-repo_id' }
  let(:params) { { } }

  describe '#create' do
    subject { provider_class.new(type.new(default_params.merge params)).create }
    context 'given a repo id' do
      it 'should pass credentials to PulpAdmin' do
        expect(PuppetPulp::PulpAdmin).
          to receive(:new).with('test-login', 'test-password').
          and_call_original
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create)

        subject
      end

      it 'should pass the repo id' do
        expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,params|
          expect(repo_id).to eq repo_id
        end
        subject
      end

      context 'and a display name' do
        let(:params) { { :display_name => display_name } }
        let(:display_name) { 'test display name' }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            expect(options[:display_name]).to eq display_name
          end

          subject
        end
      end

      context 'and a description' do
        let(:params) { { :description => description } }
        let(:description) { 'test description' }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            expect(options[:description]).to eq description
          end

          subject
        end
      end

      context 'and a feed' do
        let(:params) { { :feed => feed } }
        let(:feed) { 'http://feed.com' }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            expect(options[:feed]).to eq feed
          end

          subject
        end
      end



      context 'and notes' do
        let(:params) { { :notes => notes } }
        let(:notes) { { 'name1' => 'value1', 'name2' => 'value2' } }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            notes = options[:notes]
            expect(notes['name1']).to eq 'value1'
            expect(notes['name2']).to eq 'value2'
          end

          subject
        end
      end

      context 'and queries' do
        let(:params) { { :queries => queries } }
        let(:queries) { ['query1', 'query2'] }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            expect(options[:queries]).to eq queries
          end

          subject
        end
      end

      context 'and schedules' do
        let(:params) { { :schedules => schedules } }
        let(:schedules) { ['2012-12-15T00:00Z/P1D', '2012-12-16T00:00Z/P1D'] }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            expect(options[:schedules]).to eq schedules
          end

          subject
        end
      end

      context 'and serve_http' do
        let(:params) { { :serve_http => serve_http } }
        let(:serve_http) { true }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            expect(options[:serve_http]).to eq serve_http
          end

          subject
        end
      end

      context 'and serve_https' do
        let(:params) { { :serve_https => serve_https } }
        let(:serve_https) { true }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create) do |repo_id,options|
            expect(options[:serve_https]).to eq serve_https
          end

          subject
        end
      end
    end
  end

  describe '#destroy' do
    subject { provider_class.new(type.new(default_params.merge params)).destroy }
    context 'given a repo id' do
      it 'should call PulpAdmin#destroy' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:destroy).
            with repo_id

          subject
      end

      it 'should pass credentials to PulpAdmin' do
        expect(PuppetPulp::PulpAdmin).
          to receive(:new).with('test-login', 'test-password').
          and_call_original
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:destroy)

        subject
      end
    end
  end

  describe '#exists?' do
    subject { provider_class.new(type.new(default_params.merge params)).exists? }

    context 'given a missing repo id' do
      before do
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:repos).
          and_return({})
      end

      it { should be_false }

      it 'should pass credentials to PulpAdmin' do
        expect(PuppetPulp::PulpAdmin).
          to receive(:new).with('test-login', 'test-password').
          and_call_original
        subject
      end
    end

    context 'given an existing repo id' do
      before do
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:repos).
          and_return({'test-repo_id' => {} })
      end

      it { should be_true }

      it 'should pass credentials to PulpAdmin' do
        expect(PuppetPulp::PulpAdmin).
          to receive(:new).with('test-login', 'test-password').
          and_call_original
        subject
      end
    end
  end

  context 'given an existing repo id' do
    let(:display_name) { 'test display name' }
    let(:description) { 'test display name' }
    let(:feed) { 'http://randomfeed.com' }
    let(:notes) do
      { :note1 => 'value1',
        :note2 => 'value 2' }
    end
    let(:queries) { ['query1', 'query2'] }
    let(:schedules) { ['2012-12-15T00:00Z/P1D', '2012-12-16T00:00Z/P1D'] }
    let(:serve_http) { true }
    let(:serve_https) { true }

    let(:repo) do
      OpenStruct.new({
        :display_name => display_name,
        :description => description,
        :feed => feed,
        :notes => notes,
        :queries => queries,
        :schedules => schedules,
        :serve_http => serve_http,
        :serve_https => serve_https
      })
    end

    before do
      allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:repos).
        and_return(repo_id => repo)
    end

    its(:display_name) { should eq display_name }
    its(:description) { should eq description }
    its(:feed) { should eq feed }
    its(:notes) { should eq notes }
    its(:queries) { should eq queries }
    its(:schedules) { should eq schedules }
    its(:serve_http) { should equal serve_http }
    its(:serve_https) { should equal serve_https }

    context 'and a new display name' do
      let(:new_value) { 'new display name' }

      it 'should call display_name= on the correct repo'  do
        expect(repo).to receive(:display_name=).with new_value
        subject.display_name = new_value
      end
    end

    context 'and a new description' do
      let(:new_value) { 'new description' }

      it 'should call description= on the correct repo'  do
        expect(repo).to receive(:description=).with new_value
        subject.description = new_value
      end
    end

    context 'and a new feed' do
      let(:new_value) { 'http://newfeed.com' }

      it 'should call feed= on the correct repo'  do
        expect(repo).to receive(:feed=).with new_value
        subject.feed = new_value
      end
    end

    context 'and new notes' do
      let(:new_notes) do
        { :note3 => 'value3',
          :note4 => 'valie4' }
      end

      it 'should call notes= on the correct repo' do
        expect(repo).to receive(:notes=).with new_notes
        subject.notes = new_notes
      end
    end

    context 'and new queries' do
      let(:new_queries) { ['query3', 'query4' ] }

      it 'should call queries= on the correct repo' do
        expect(repo).to receive(:queries=).with new_queries
        subject.queries = new_queries
      end
    end

    context 'and new schedules' do
      let(:new_schedules) { ['2012-12-15T00:00Z/P1D', '2012-12-16T00:00Z/P1D' ] }

      it 'should call schedules= on the correct repo' do
        expect(repo).to receive(:schedules=).with new_schedules
        subject.schedules = new_schedules
      end
    end

    context 'and a new serve http value' do
      let(:new_serve_http) { false }

      it 'should call serve_http= on the correct repo' do
        expect(repo).to receive(:serve_http=).with new_serve_http
        subject.serve_http = new_serve_http
      end
    end

    context 'and a new serve https value' do
      let(:new_serve_https) { false }

      it 'should call serve_httsp= on the correct repo' do
        expect(repo).to receive(:serve_https=).with new_serve_https
        subject.serve_https = new_serve_https
      end
    end
  end
end
