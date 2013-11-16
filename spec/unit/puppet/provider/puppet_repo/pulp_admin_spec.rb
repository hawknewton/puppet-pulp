require 'spec_helper'
type = Puppet::Type.type :puppet_repo
provider_class = type.provider :pulp_admin

puts provider_class.inspect

describe provider_class do
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

  describe '#display_name' do
    subject { provider_class.new(type.new({:id => repo_id}.merge params)).display_name }

    context 'given an existing repo id' do
      before do
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:repos).
          and_return(repo_id => OpenStruct.new({:display_name => display_name}))
      end

      context 'and display name = \'test-display_name\'' do
        let(:display_name) { 'test-display_name' }

        it { should eq 'test-display_name' }
      end
    end
  end

  describe '#display_name=' do
    subject { provider_class.new(type.new({:id => repo_id}.merge params)).display_name = new_value}

    context 'given an existing repo id' do
      let(:repo) { OpenStruct.new({:display_name => display_name}) }

      before do
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:repos).
          and_return(repo_id => repo)
      end

      context 'and display name = \'old display name\'' do
        let(:display_name) { 'old display name' }

        context 'and the new display name' do
          let(:new_value) { 'new display name' }

          it 'should call display= on the correct repo'  do
            expect(repo).to receive(:display_name=).with new_value
            subject
          end
        end
      end
    end
  end
end
