require 'heroku'

module Delayed
  module Workless
    module Scaler

      class HerokuCedar < Base

        extend Delayed::Workless::Scaler::HerokuClient

        def self.up
          nw = self.calculate_num_workers
          if nw
            if self.num_workers_cache != nw
              self.num_workers_cache = nw
              client.ps_scale(ENV['APP_NAME'], :type => 'worker', :qty => nw) 
            end
          end
        rescue
        end

        def self.down
          nw = self.calculate_num_workers
          if nw
            if self.num_workers_cache != nw
              self.num_workers_cache = nw
              client.ps_scale(ENV['APP_NAME'], :type => 'worker', :qty => nw)
            end
          end          
        rescue
        end
      end

      def self.workers
        client.ps(ENV['APP_NAME']).count { |p| p["process"] =~ /worker\.\d?/ }
      end

    end
  end
end
