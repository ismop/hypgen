require 'faraday'
require 'json'

module Dap
  class Cli
    include RestCli

    def create_threat_assessment_run(name, section_ids, start_time, end_time)
      puts "1. creating new experiment for #{section_ids} profiles with period #{start_time} - #{end_time}"

      response = connection.post do |req|
        req.url '/api/v1/threat_assessments'
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          threat_assessment: {
            name: name,
            start_date: start_time,
            end_date: end_time,
            section_ids: section_ids,
            status: :started
          }
        }.to_json
      end

      raise(ThreatAssessmentRunCreationError, response.body) unless response.status == 201

      JSON.parse(response.body)['threat_assessment']['id']
    end

    def update_threat_assessment_run(exp_id, updated_fields)
      puts "Updating #{exp_id} experiment with following fields #{updated_fields}"

      response = connection.put do |req|
        req.url "/api/v1/threat_assessments/#{exp_id}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { threat_assessment: updated_fields }.to_json
      end

      raise(ThreatAssessmentRunUpdateError, response.body) unless response.status == 200
    end
  end

  class ThreatAssessmentRunCreationError < Exception
  end

  class ThreatAssessmentRunUpdateError < Exception
  end
end