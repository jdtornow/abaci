module Abaci
  class Railtie < Rails::Railtie

    initializer "abaci.set_time_zone" do |app|
      Abaci.time_zone = app.config.time_zone
    end

  end
end
