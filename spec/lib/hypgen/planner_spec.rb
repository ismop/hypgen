require 'spec_helper'

describe Hypgen::Planner do

  it 'should plan workflow' do

    workflow_json = File.read("spec/lib/hypgen/test_wf.json")
    puts workflow_json
    workflow = double("workflow")
    allow(workflow).to receive(:as_json) {workflow_json}
    allow(workflow).to receive(:external_dependencies) {
      [
        { init_conf_tmp_id: 7, params: { experimentId: @experimentId, dap_token: Hypgen.config.dap_token } },
      ]}
    planner = Hypgen::Planner.new(workflow)
    setup     = planner.setup

    puts setup[0][:vms]

    expect(setup[0][:vms].count).to eq(3)

  end
end