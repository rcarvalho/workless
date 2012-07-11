require 'heroku'

module Delayed
  module Workless
    module Scaler

      class HerokuCedar < Base

        extend Delayed::Workless::Scaler::HerokuClient

        def self.up
          @@current_num_workers || 0
          nw = self.calculate_num_workers
          if nw
            if @@current_num_workers != nw
              @@current_num_workers = nw
              client.ps_scale(ENV['APP_NAME'], :type => 'worker', :qty => @@current_num_workers) 
            end
          end
        rescue
        end

        def self.down
          @@current_num_workers || 0
          nw = self.calculate_num_workers
          if nw
            if @@current_num_workers != nw
              @@current_num_workers = nw
              client.ps_scale(ENV['APP_NAME'], :type => 'worker', :qty => nw)
            end
          end          
        rescue
        end

        def self.workers
          @@current_num_workers || 0
          @@current_num_workers || client.ps(ENV['APP_NAME']).count { |p| p["process"] =~ /worker\.\d?/ }
        end

      end

    end
  end
end
