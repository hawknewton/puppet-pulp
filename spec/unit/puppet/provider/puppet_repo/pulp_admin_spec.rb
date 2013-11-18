require 'spec_helper'
type = Puppet::Type.type :puppet_repo
provider_class = type.provider :pulp_admin

puts provider_class.inspect

describe provider_class do
  subject { provider_class.new(type.new({:id => repo_id}.merge params)) }

  let(:repo_id) { 'test-repo_id' }
  let(:params) { { } }

  describe '#create' do
    subject { provider_class.new(type.new({:id => repo_id}.merge params)).create }
    context 'given a repo id' do
      context 'and a display name' do
        let(:params) { { :display_name => display_name } }
        let(:display_name) { 'test display name' }

        it 'should call PulpAdmin#create' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).to receive(:create).
            with repo_id, { :display_name => display_name }

          subject
        end
      end
    end
  end

  describe '#exists?' do
    subject { provider_class.new(type.new({:id => repo_id}.merge params)).exists? }

    context 'given a missing repo id' do
      before do
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:repos).
          and_return({})
      end

      it { should be_false }
    end

    context 'given an existing repo id' do
      before do
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:repos).
          and_return({'test-repo_id' => {} })
      end

      it { should be_true }
    end
  end

  context 'given an existing repo id' do
    let(:display_name) { 'test display name' }
    let(:description) { 'test display name' }
    let(:notes) do
      { :note1 => 'value1',
        :note2 => 'value 2' }
    end
    let(:queries) { ['query1', 'query2'] }
    let(:serve_http) { true }
    let(:serve_https) { true }

    let(:repo) do
      OpenStruct.new({
        :display_name => display_name,
        :description => description,
        :notes => notes,
        :queries => queries,
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
    its(:notes) { should eq notes }
    its(:queries) { should eq queries }
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
