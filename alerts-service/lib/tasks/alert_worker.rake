namespace :alerts do
  desc "Check alert cooldowns in an infinite loop"
  task worker: :environment do
    puts "Starting Alert Cooldown Checker..."

    loop do
      Alert.active.find_each do |alert|
        cooldown_s = 3

        if Time.current - alert.last_trigger_at > cooldown_s
          alert.close!
          puts "Closed alert #{alert.id} (rule #{alert.rule_id}, car #{alert.car_code})"
        end
      end

      sleep 1
    end
  end
end
