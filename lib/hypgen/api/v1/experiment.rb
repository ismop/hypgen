module Hypgen
  module Api
    module V1
      class Experiment < Grape::API

        resource :experiments do
          get do
            { help: 'REST interface for starting ISMOP experiment'}
          end

          params do
            requires :experiment, type: Hash  do
              requires :name, type: String
              requires :profile_ids, type: Array
              requires :start_date, type: Time
              requires :end_date, type: Time
              optional :deadline, type: Integer, default: 500
            end
          end
          post do
            exp = Hypgen::Experiment.new(
              params[:experiment][:name],
              params[:experiment][:profile_ids],
              params[:experiment][:start_date],
              params[:experiment][:end_date],
              params[:experiment][:deadline])

            exp.start!

            status 201
            {
              meta: {
                url: "https://dap.moc.ismop.edu.pl/api/v1/experiments/#{exp.id}"
              },
              experiment: {
                id: exp.id
              }
            }
          end
        end
      end
    end
  end
end
