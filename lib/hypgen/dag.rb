require 'json'
require 'recursive-open-struct'
require 'rgl/adjacency'
require 'rgl/topsort'
require 'rgl/dot'

module Hypgen
  class Dag

    attr_accessor :dag

    def initialize(workflow_json)
      @wf_hash = JSON.parse(workflow_json)
      @wf = RecursiveOpenStruct.new(@wf_hash,:recurse_over_arrays => true)
      @dag = create_dag(@wf)
    end


    def create_dag(wf)
      dag = RGL::DirectedAdjacencyGraph.new
      wf.processes.each do|p|
        p.outs.each do |o|
          child = wf.processes.find{ |c| c.ins.include? o}
          puts "#{p.name} --[#{o}]--> #{child.name}"
          dag.add_edge(p.name, child.name)
        end
      end
      dag
    end


    def compute_levels
      level = Hash.new
      @dag.topsort_iterator.each{ |v| level[v]=0 }
      @dag.topsort_iterator.each{ |v|
        @dag.adjacent_vertices(v).each{ |c|
          level[c] = level[v] + 1 if level[c] <= level[v]
        }
      }
      @dag.topsort_iterator.each{ |v| puts "#{v}: level #{level[v]}" }
      level
    end


    def decorate_levels(level)
      @wf_hash['processes'].each do|p|
        p['level'] = level[p['name']]
      end
    end

    def to_json
      JSON.pretty_generate @wf_hash
    end

    def to_png
      dag.write_to_graphic_file('png')
    end

  end
end