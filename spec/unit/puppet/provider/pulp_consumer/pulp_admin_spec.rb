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
          with consumer_id
        subject
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
              :consumer_id => consumer_id
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
end
