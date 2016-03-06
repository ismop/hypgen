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
    stubs.post('api/v1/threat_assessments') do |env|
      exp_request = JSON.parse(env.body)['threat_assessment']

      expect(exp_request['name']).to eq 'exp'
      expect(exp_request['start_date']).to eq 'start_d'
      expect(exp_request['end_date']).to eq 'end_d'
      expect(exp_request['section_ids']).to eq [1, 2, 3]
      expect(exp_request['status']).to eq 'started'

      [201, {}, '{"threat_assessment":{"id": 123}}']
    end

    expect(subject.create_threat_assessment_run('exp', [1, 2, 3], 'start_d', 'end_d')).to eq 123
  end

  it 'throws exception when unable to create experiment' do
    stubs.post('api/v1/threat_assessments') do |env|
      [400, {}, '{"message": "appliance init conf not found"}']
    end

    expect { subject.create_threat_assessment_run('exp', [1] , 's', 'e') }.to raise_error(Dap::ThreatAssessmentRunCreationError)
  end

  it 'updates experiment fields' do
    stubs.put('api/v1/threat_assessments/123') do |env|
      exp_request = JSON.parse(env.body)['threat_assessment']

      expect(exp_request['status']).to eq 'error'
      expect(exp_request['status_message']).to eq 'error msg'

      [200, {}, '']
    end

    subject.update_threat_assessment_run(123, {status: :error, status_message: 'error msg' })
  end

  it 'failed to update experiment' do
    stubs.put('api/v1/threat_assessments/123') do |env|
      [400, {}, '{"message": "err"}']
    end

    expect { subject.update_threat_assessment_run(123 , {}) }.to raise_error(Dap::ThreatAssessmentRunUpdateError)
  end
end