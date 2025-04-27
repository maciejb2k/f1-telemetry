namespace :rabbitmq do
  task listen: :environment do
    Rabbitmq::Listener.start
  end
end
