# Set of methods allowing to audit experiment.
#
# It is required to deliver method `id` in order to make auditable
# method works.
module Hypgen
  module Auditable
    # Log information with experiment id and current time before code
    # defined in block is executed. After it is finised another log is created
    # with task duration.
    def audit(task, options = {})
      start_time = Time.now
      log("Starting '#{task}' task", options[:log_level])
      yield
    ensure
      log("'#{task}' took #{Time.now - start_time} seconds to execute",
          options[:log_level])
    end

    private

    def log(msg, log_level)
      log_level == :info ? logger.info(msg) : logger.debug(msg)
    end

    def logger
      @logger ||= create_logger
    end

    def create_logger
      logger = Logger.new(logger_path)
      original_formatter = Logger::Formatter.new
      logger.formatter = proc do |severity, datetime, progname, msg|
        original_formatter.
          call("Exp #{id} #{severity}", datetime, progname, msg.dump)
      end

      logger
    end

    def logger_path
      file_name = if Hypgen.config.trace?
                    "experiment_#{id}.log"
                  else
                    'experiments.log'
                  end

      File.join(Hypgen.config.log_dir, file_name)
    end
  end
end
