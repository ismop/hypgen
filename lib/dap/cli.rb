require 'faraday'
require 'json'

module Dap
  class Cli
    include RestCli

    #TODO: remove unused sections_ids
    def create_threat_assessment_run(name, section_ids, start_time, end_time)
      puts "1. creating new threat assessment run for #{section_ids} profiles with period #{start_time} - #{end_time}"

      response = connection.post do |req|
        req.url '/api/v1/threat_assessment_runs'
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          threat_assessment_run: {
            name: name,
            start_date: start_time,
            end_date: end_time,
            status: :started
          }
        }.to_json
      end

      raise(ThreatAssessmentRunCreationError, response.body) unless response.status == 201

      JSON.parse(response.body)['threat_assessment_run']['id']
    end

    def update_threat_assessment_run(tar_id, updated_fields)
      puts "Updating #{tar_id} threat assessment run with following fields #{updated_fields}"

      response = connection.put do |req|
        req.url "/api/v1/threat_assessment_runs/#{tar_id}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { threat_assessment_run: updated_fields }.to_json
      end

      raise(ThreatAssessmentRunUpdateError, response.body) unless response.status == 200
    end

    def create_threat_assessment(threat_assessment_run_id, profiles)
      puts "1a. creating new threat assesment for #{profiles} profiles"

      response = connection.post do |req|
        req.url '/api/v1/threat_assessments'
        req.headers['Content-Type'] = 'application/json'
        req.body = {
            threat_assessment: {
                profiles: profiles,
                threat_assessment_run_id: threat_assessment_run_id
            }
        }.to_json
      end

      raise(ThreatAssessmentCreationError, response.body) unless response.status == 201

      JSON.parse(response.body)['threat_assessment']['id']
    end
  end

  class ThreatAssessmentRunCreationError < Exception
  end

  class ThreatAssessmentCreationError < Exception
  end

  class ThreatAssessmentRunUpdateError < Exception
  end
end