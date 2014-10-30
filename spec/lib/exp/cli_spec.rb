require 'spec_helper'

describe Exp::Cli do

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) do
    Faraday.new do |builder|
      builder.adapter :test, stubs
    end
  end

  subject { Exp::Cli.new(connection: connection) }

  it 'starts new appliance set' do
    stubs.post('api/v1/appliance_sets') do |env|
      as_request = JSON.parse(env.body)['appliance_set']

      expect(as_request['name']).to start_with('HypGen')
      expect(as_request['priority']).to eq(50)
      expect(as_request['appliance_set_type']).to eq('workflow')
      expect(as_request['appliances']).to eq([{'init_conf_id' => 1}])

      [201, {}, '{"appliance_set":{"id": 123}}']
    end

    expect(subject.start_as([
        { init_conf_id: 1}
      ])).to eq(123)
  end

  it 'throws exception when unable to start appliance set' do
    stubs.post('api/v1/appliance_sets') do |env|
      [400, {}, '{"message": "appliance init conf not found"}']
    end

    expect { subject.start_as([]) }.to raise_error(Exp::AsCreationError)
  end

  it 'stops appliance set' do
    stubs.delete('api/v1/appliance_sets/123') do |env|
      [200, {}, '']
    end

    subject.stop_as(123)

    stubs.verify_stubbed_calls
  end
end