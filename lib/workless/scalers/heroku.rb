require 'heroku'

module Delayed
  module Workless
    module Scaler

      class Heroku < Base

        extend Delayed::Workless::Scaler::HerokuClient

        def self.up
          nw = self.calculate_num_workers(true)
          if nw
            if self.num_workers_cache != nw
              self.num_workers_cache = nw
              client.set_workers(ENV['APP_NAME'], nw)
            end
          end
        rescue          
        end

        def self.down
          nw = self.calculate_num_workers
          if nw
            if self.num_workers_cache != nw
              self.num_workers_cache = nw
              client.set_workers(ENV['APP_NAME'], nw)
            end
          end          
        rescue
        end

        def self.workers
          client.info(ENV['APP_NAME'])[:workers].to_i
        end

      end

    end
  end
end
