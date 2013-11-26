require 'spec_helper'
require 'ostruct'

type = Puppet::Type.type :pulp_consumer
provider_class = type.provider :pulp_admin

describe provider_class do
  subject { provider_class.new(type.new(default_params.merge params)) }

  let(:default_params) do
    { :id => consumer_id,
      :login => 'test-login',
      :password => 'test-password' }
  end

  let(:consumer_id) { 'test-consumer_id' }
  let(:params) { { } }


  describe '#create' do
    subject { provider_class.new(type.new(default_params.merge params)).create }
    context 'given a consumer id' do
      it 'should pass credentials to PulpAdmin' do
        expect(PuppetPulp::PulpAdmin).
          to receive(:new).with('test-login', 'test-password').
          and_call_original
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:register_consumer)

        subject
      end

      it 'should pass the consumer id' do
        expect_any_instance_of(PuppetPulp::PulpAdmin).
          to receive(:register_consumer).
          with consumer_id, anything
        subject
      end

      context 'and a description' do
        let(:params) { { :description => description } }
        let(:description) { 'test description' }

        it 'should pass the description' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).
            to receive(:register_consumer) do |consumer_id,options|
            expect(options[:description]).to eq description
          end
          subject
        end
      end


      context 'and a display name' do
        let(:params) { { :display_name => display_name } }
        let(:display_name) { 'test display name' }

        it 'should pass the description' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).
            to receive(:register_consumer) do |consumer_id,options|
            expect(options[:display_name]).to eq display_name
          end
          subject
        end
      end

      context 'and notes' do
        let(:params) { { :notes => notes } }
        let(:notes) { { 'name1' => 'value1', 'name2' => 'value2' } }

        it 'should pass the description' do
          expect_any_instance_of(PuppetPulp::PulpAdmin).
            to receive(:register_consumer) do |consumer_id,options|
            expect(options[:notes]).to eq notes
          end
          subject
        end
      end
    end
  end

  describe '#destroy' do
    subject { provider_class.new(type.new(default_params.merge params)).destroy }

    context 'given a consumder id' do
      it 'should pass credentials to PulpAdmin' do
        expect(PuppetPulp::PulpAdmin).
          to receive(:new).with('test-login', 'test-password').
          and_call_original

        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:unregister_consumer)
        subject
      end

      it 'should pass consumer id' do
        expect_any_instance_of(PuppetPulp::PulpAdmin).
          to receive(:unregister_consumer).
          with consumer_id

        subject
      end
    end
  end

  describe 'exists?' do
    subject { provider_class.new(type.new(default_params.merge params)).exists? }

    context 'given a consumer id' do
      it 'should pass credentials to PulpAdmin' do
        allow_any_instance_of(PuppetPulp::PulpAdmin).to receive(:consumer)

        expect(PuppetPulp::PulpAdmin).
          to receive(:new).with('test-login', 'test-password').
          and_call_original

        subject
      end

      context 'that is currently registered' do
        example do
          expect_any_instance_of(PuppetPulp::PulpAdmin).
            to receive(:consumer).
            and_return(OpenStruct.new({
              :id => consumer_id
            }))

            should be_true
        end
      end

      context 'that is different than the current id' do
        example do
          expect_any_instance_of(PuppetPulp::PulpAdmin).
            to receive(:consumer).
            and_return(OpenStruct.new({
              :id => 'bunk_id'
            }))

            should be_false
        end
      end

      context 'with no registration' do
        example do
          expect_any_instance_of(PuppetPulp::PulpAdmin).
            to receive(:consumer).
            and_return nil

            should be_false
        end
      end
    end
  end

  context 'given an existing consumer id' do
    let(:consumer) do
      OpenStruct.new({
        :id => consumer_id,
        :description => description,
        :display_name => display_name,
        :notes => notes
      })
    end

    let(:description) { 'test description' }
    let(:display_name) { 'test display name' }
    let(:notes) { { 'name1' => 'value1', 'name2' => 'value2' } }

    before do
      allow_any_instance_of(PuppetPulp::PulpAdmin).
        to receive(:consumer).
        and_return consumer
    end

    its(:description) { should eq description }
    its(:display_name) { should eq display_name }
    its(:notes) { should eq notes }

    context 'with a new description' do
      let(:new_description) { 'new test description' }

      it 'should call consumer.description=' do

        expect(consumer).
          to receive(:description=).
          with new_description

        subject.description = new_description
      end
    end


    context 'with a new display name' do
      let(:new_display_name) { 'new display name' }

      it 'should call consumer.display_name=' do

        expect(consumer).
          to receive(:display_name=).
          with new_display_name

        subject.display_name = new_display_name
      end
    end

    context 'with new notes' do
      let(:new_notes) { { 'name3' => 'value3', 'name4' => 'value4'} }

      it 'should call consumer.notes=' do
        expect(consumer).
          to receive(:notes=).
          with new_notes

        subject.notes = new_notes
      end
    end
  end
end
