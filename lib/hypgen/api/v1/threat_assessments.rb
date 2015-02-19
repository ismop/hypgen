module Hypgen
  module Api
    module V1
      class ThreatAssessments < Grape::API

        resource :threat_assessments do
          get do
            { help: 'REST interface for starting ISMOP threat assessment'}
          end

          params do
            requires :threat_assessment, type: Hash  do
              requires :name, type: String
              requires :section_ids, type: Array
              requires :start_date, type: Time
              requires :end_date, type: Time
              optional :deadline, type: Integer, default: 500
            end
          end
          post do
            exp = Hypgen::Experiment.new(
              params[:threat_assessment][:name],
              params[:threat_assessment][:section_ids],
              params[:threat_assessment][:start_date],
              params[:threat_assessment][:end_date],
              params[:threat_assessment][:deadline])

            exp.start!

            status 201
            {
              meta: {
                url: "#{Hypgen.config.dap_url}/api/v1/threat_assessments/#{exp.id}"
              },
              threat_assessment: {
                id: exp.id
              }
            }
          end
        end
      end
    end
  end
end
