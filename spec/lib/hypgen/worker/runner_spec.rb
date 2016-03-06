require 'spec_helper'

describe Hypgen::Worker::Runner do
  it 'start all experiment parts' do
    workflow_class = double
    workflow = instance_double('Hypgen::Workflow', set_set_id: true)

    planner_class = double
    planner = instance_double('Hypgen::Planner')
    exp_client = instance_double('Exp::Cli')
    dap_client = instance_double('Dap::Cli')

    allow(workflow_class).
      to receive(:new).
      with(1, 'profiles', 'location', 'start', 'end', 'deadline').
      and_return(workflow)

    allow(planner_class).
      to receive(:new).
      with(workflow).
      and_return(planner)

    subject = Hypgen::Worker::Runner.
      new(1, 'profiles', 'location', 'start', 'end', 'deadline',
          workflow: workflow_class,
          planner: planner_class,
          exp_client: exp_client,
          dap_client: dap_client)

    expect(planner).
      to receive(:setup).
      and_return('setup')

    expect(exp_client).
      to receive(:start_as).
      with('setup', anything).
      and_return('as_id')

    expect(workflow).
      to receive(:run!).
      and_return(0)

    expect(dap_client).
      to receive(:update_threat_assessment_run).
      with(1, status: :finished)

    expect(exp_client).
      to receive(:stop_as).
      with('as_id')

    subject.execute
  end
end
