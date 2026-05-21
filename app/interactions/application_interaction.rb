# frozen_string_literal: true

# Базовый класс для всех интеракторов.
#
# Оборачивает run и run! — пишет метрики и перехватывает исключения в errors.log.

class ApplicationInteraction < ActiveInteraction::Base
  def self.run(inputs = {})
    measure { super }
  rescue StandardError => e
    Yabeda.interaction_errors_total.increment(interaction: name.demodulize.underscore, type: e.class.name)
    ErrorLogger.log(e, context: { interaction: name })
    raise
  end

  def self.run!(inputs = {})
    measure { super }
  rescue StandardError => e
    Yabeda.interaction_errors_total.increment(interaction: name.demodulize.underscore, type: e.class.name)
    ErrorLogger.log(e, context: { interaction: name })
    raise
  end

  def self.measure
    interaction = name.demodulize.underscore
    Yabeda.interaction_calls_total.increment(interaction: interaction)
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
  ensure
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    Yabeda.interaction_duration_seconds.measure({ interaction: interaction }, duration)
  end

  private_class_method :measure
end
