require 'delayed_job'

module Delayed
  module Workless
    module Scaler
  
      class Base
        def self.jobs
          Delayed::Job.all(:conditions => { :failed_at => nil })
        end
        
        def self.calculate_num_workers
          num_workers = self.workers
          if num_workers.class == Fixnum
            job_count = self.jobs.count
            if job_count > 500
              return 4 unless num_workers > 3
            elsif job_count > 200
              return 3 unless num_workers > 2
            elsif job_count > 50
              return 2 unless num_workers > 1
            elsif job_count > 0
              return 1 unless num_workers > 0
            end
          end
        end
      end

      module HerokuClient

        def client
          @client ||= ::Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
        end

      end

    end
  end
end
