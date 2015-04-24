require 'spec_helper'

describe Hypgen::Dag do

  it 'should create dag' do
    workflow_json = File.read("spec/lib/hypgen/test_wf.json")
    dag = Hypgen::Dag.new(workflow_json)

    expect(dag.dag.acyclic?).to eq(true)
    expect(dag.dag.vertices.size).to eq(7)
  end

  it 'should compute levels' do
    workflow_json = File.read("spec/lib/hypgen/test_wf.json")
    dag = Hypgen::Dag.new(workflow_json)

    levels = dag.compute_levels
    expect(levels['SaveResults']).to eq(2)
  end

  it 'should compute levels' do
    workflow_json = File.read("spec/lib/hypgen/test_wf.json")
    dag = Hypgen::Dag.new(workflow_json)
    levels = dag.compute_levels

    dag.decorate_levels (levels)
    expect(dag.to_json). to include('"level": 2')
    puts dag.to_json
  end
end