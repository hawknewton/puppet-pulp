require 'spec_helper'

type = Puppet::Type.type(:puppet_repo)

describe type do
  subject { type.new({name: name}.merge params) }
  let(:params) { { } }

  context 'given an invalid name' do
    let(:name) { 'test 123' }

    example do
      expect { subject }.to raise_error Puppet::Error, /name may contain only alphanumberic, ., -, and _/
    end
  end

  context 'given a valid name' do
    let(:name) { 'test_123' }

    example do
      expect { subject }.to_not raise_error
    end

    context 'and an invalid serve_http' do
      let(:params) { { serve_http: 'adf' } }

      example do
        expect { subject }.to raise_error Puppet::Error, /serve_http must be a boolean value/
      end
    end

    context 'and valid boolean serve_http' do
      let(:params) { { serve_http: true } }
      example { expect { subject }.to_not raise_error }
    end

    context 'and an invalid serve_https' do
      let(:params) { { serve_https: 'adf' } }

      example do
        expect { subject }.to raise_error Puppet::Error, /serve_https must be a boolean value/
      end
    end

    context 'and a valid serve_https' do
      let(:params) { { serve_https: true } }
      example { expect { subject }.to_not raise_error }
    end


    context 'and an invalid feed url' do
      let(:params) { { feed: 'asdfasdfasdfsd' } }

      example do
        expect { subject }.to raise_error Puppet::Error, /feed must be a valid url/
      end
    end

    context 'and an valid feed url' do
      let(:params) { { feed: 'http://someurl.com' } }

      example do
        expect { subject }.to_not raise_error
      end
    end

    context 'given a dispaly_name' do
      let(:params) { { display_name: 'Display name.  123' } }
      example do
        expect { subject }.to_not raise_error
      end
    end

    context 'given a description' do
      let(:params) { { description: 'Display name.  123' } }
      example do
        expect { subject }.to_not raise_error
      end
    end

    context 'given valid notes' do
      let(:params) { { notes: { note1: 'value1' } } }
      example do
        expect { subject }.to_not raise_error
      end
    end

    context 'given an invalid note' do
      let(:params) { { notes: 'adfasdfasfasdf' } }
      example do
        expect { subject }.to raise_error Puppet::Error, /notes must be a map/
      end
    end

    context 'given a valid query' do
      let(:params) { { queries: ['query1'] } }
      example do
        expect { subject }.to_not raise_error
      end
    end

  end
end
