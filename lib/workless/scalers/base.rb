require 'delayed_job'

module Delayed
  module Workless
    module Scaler
  
      class Base
        def self.jobs
          Delayed::Job.where(:failed_at => nil)
        end

        def self.scale_info= info
          @@scale_info = info
        end

        def self.num_workers_cache
          Rails.cache.read("WORKLESS_NUM_WORKERS") || 0
        end

        def self.num_workers_cache= num
          Rails.cache.write("WORKLESS_NUM_WORKERS", num)
        end
        
        def self.calculate_num_workers up=false
          num_jobs = self.jobs.count
          @@scale_info ||= {
            0 => 0,
            100 => 1,
            500 => 2,
            1000 => 3
          }
          scale_key = nil
          if up
            scale_key = @@scale_info.keys.select{|v| v > num_jobs }.first
            scale_key ||= @@scale_info.keys.last
          else
            scale_key = @@scale_info.keys.select{|v| v > num_jobs }.first
            scale_key = 0 if num_jobs == 0 # special case
          end
          
          if scale_key.nil?
            return 0
          else
            return @@scale_info[scale_key]
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
