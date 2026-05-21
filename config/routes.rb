# frozen_string_literal: true

Rails.application.routes.draw do
  resources :todos, only: %i[index show create]

  # Эндпоинт для Prometheus — он сам ходит сюда каждые N секунд и забирает метрики (pull-модель).
  # Yabeda::Prometheus::Exporter — это Rack-приложение, смонтированное как обычный маршрут.
  # Ответ отдаётся в text/plain формате понятном Prometheus (exposition format).
  mount Yabeda::Prometheus::Exporter => '/metrics'
end
