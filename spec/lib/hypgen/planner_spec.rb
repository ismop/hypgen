require 'spec_helper'

describe Hypgen::Planner do

  it 'should plan workflow' do
    workflow_json = File.read("spec/lib/hypgen/test_wf.json")
    puts workflow_json
    workflow = double("workflow")
    allow(workflow).to receive(:as_json) {workflow_json}
    allow(workflow).to receive(:deadline) {60}
    allow(workflow).to receive(:external_dependencies) {
      [
        { init_conf_tmp_id: 7, params: { experimentId: @experimentId, dap_token: Hypgen.config.dap_token } },
      ]}
    allow(workflow).to receive(:start_time) {"2014-11-19T09:45:42.025Z"}
    allow(workflow).to receive(:end_time) {"2014-11-20T09:45:42.025Z"}
    planner = Hypgen::Planner.new(workflow)
    setup     = planner.setup

    puts setup[0][:vms]

    expect(setup[0][:vms].count).to eq(2)
  end

  it 'should read start and end time from workflow' do
    workflow = double("workflow")
    allow(workflow).to receive(:deadline) {60}

    allow(workflow).to receive(:start_time) {"2014-11-19T09:45:42.025Z"}
    allow(workflow).to receive(:end_time) {"2014-11-20T09:45:42.025Z"}
    planner = Hypgen::Planner.new(workflow)
    expect(planner.days).to eq(1)

    allow(workflow).to receive(:start_time) {"2014-11-19T09:45:42.025Z"}
    allow(workflow).to receive(:end_time) {"2014-11-21T09:45:42.025Z"}
    planner = Hypgen::Planner.new(workflow)
    expect(planner.days).to eq(2)

    allow(workflow).to receive(:start_time) {"2014-11-19T09:45:42.035Z"}
    allow(workflow).to receive(:end_time) {"2014-11-20T09:45:42.025Z"}
    planner = Hypgen::Planner.new(workflow)
    expect(planner.days).to eq(1)
  end

  it 'should compute performance model' do
    workflow = double("workflow")
    allow(workflow).to receive(:deadline) {60}

    # these values are not used in the test
    allow(workflow).to receive(:start_time) {"2014-11-19T09:45:42.025Z"}
    allow(workflow).to receive(:end_time) {"2014-11-20T09:45:42.025Z"}
    planner = Hypgen::Planner.new(workflow)

    # test some known examples
    expect(planner.compute_perf_model(128, 3, 278)).to eq(14)
    expect(planner.compute_perf_model(256, 1, 292)).to eq(11)
    expect(planner.compute_perf_model(128, 1, 862)).to eq(2)
    expect(planner.compute_perf_model(128, 1, 205)).to eq(10)
    expect(planner.compute_perf_model(1024, 1, 6721)).to eq(2)

    # test that negative vm count is replaced by 1
    expect(planner.compute_perf_model(128, 278, 3)).to eq(1)
  end

end