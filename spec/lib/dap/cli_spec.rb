require 'spec_helper'

describe Dap::Cli do

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) do
    Faraday.new do |builder|
      builder.adapter :test, stubs
    end
  end

  subject { Dap::Cli.new(connection: connection) }

  it 'creates new experiment' do
    stubs.post('api/v1/experiments') do |env|
      exp_request = JSON.parse(env.body)['experiment']

      expect(exp_request['name']).to eq 'exp'
      expect(exp_request['start_date']).to eq 'start_d'
      expect(exp_request['end_date']).to eq 'end_d'
      expect(exp_request['profile_ids']).to eq [1, 2, 3]
      expect(exp_request['status']).to eq 'started'

      [201, {}, '{"experiment":{"id": 123}}']
    end

    expect(subject.create_exp('exp', [1, 2, 3], 'start_d', 'end_d')).to eq 123
  end

  it 'throws exception when unable to create experiment' do
    stubs.post('api/v1/experiments') do |env|
      [400, {}, '{"message": "appliance init conf not found"}']
    end

    expect { subject.create_exp('exp', [1] ,'s', 'e') }.to raise_error(Dap::ExpCreationError)
  end

  it 'updates experiment fields' do
    stubs.put('api/v1/experiments/123') do |env|
      exp_request = JSON.parse(env.body)['experiment']

      expect(exp_request['status']).to eq 'error'
      expect(exp_request['status_message']).to eq 'error msg'

      [200, {}, '']
    end

    subject.update_exp(123, { status: :error, status_message: 'error msg' })
  end

  it 'failed to update experiment' do
    stubs.put('api/v1/experiments/123') do |env|
      [400, {}, '{"message": "err"}']
    end

    expect { subject.update_exp(123 ,{}) }.to raise_error(Dap::ExpUpdateError)
  end
end