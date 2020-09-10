Rails.application.config.to_prepare do
  ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
    case subscriber
    when ActionView::LogSubscriber
      events = subscriber.public_methods(false).reject { |method| method.to_s == 'call' }
      events.each do |event|
        ActiveSupport::Notifications.notifier.listeners_for("#{event}.#{:action_view}").each do |listener|
          if listener.instance_variable_get('@delegate') == subscriber
            ActiveSupport::Notifications.unsubscribe listener
          end
        end
      end
    end
  end
end
