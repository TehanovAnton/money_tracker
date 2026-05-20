# frozen_string_literal: true

# Базовый класс для всех интеракторов.
#
# Оборачивает run и run! — перехватывает исключения, пишет в errors.log и пробрасывает дальше.
# Контекст лога содержит имя интерактора и входные параметры (inputs).

class ApplicationInteraction < ActiveInteraction::Base
  def self.run(inputs = {})
    super
  rescue StandardError => e
    ErrorLogger.log(e, context: { interaction: name })
    raise
  end

  def self.run!(inputs = {})
    super
  rescue StandardError => e
    ErrorLogger.log(e, context: { interaction: name })
    raise
  end
end
