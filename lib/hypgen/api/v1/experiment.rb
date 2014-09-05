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
              requires :profile_ids, type: Array
              requires :start, type: Date
              requires :end, type: Date
            end
          end
          post do
            exp = Hypgen::Experiment.new(
              params[:experiment][:profile_ids],
              params[:experiment][:start],
              params[:experiment][:end])

            exp.start!

            redirect "https://dap.moc.ismop.edu.pl/api/v1/experiments/#{exp.id}"
          end
        end
      end
    end
  end
end
