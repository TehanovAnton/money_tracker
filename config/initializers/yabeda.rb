# frozen_string_literal: true

# Yabeda.configure — единое место объявления всех метрик приложения.
# Метрики регистрируются один раз при старте, после чего доступны глобально
# через Yabeda.<metric_name>.
#
# Типы метрик:
#   counter   — монотонно растущее число (запросы, ошибки). Никогда не уменьшается.
#   gauge     — произвольное число которое может расти и падать (размер очереди, кол-во соединений).
#   histogram — распределение значений по бакетам (время выполнения, размер ответа).
#               Из гистограммы можно вычислить перцентили (p50, p95, p99).
#
# tags — метки которые позволяют разбивать одну метрику на срезы.
# Например, counter :telegram_commands_total с тегом :command даёт отдельный
# счётчик для каждой команды: /start, /add, /balance и т.д.
Yabeda.configure do
  # Тег :interaction содержит имя класса интерактора в snake_case,
  # например: add_expense_service, upsert_expense_service.
  # Это позволяет фильтровать метрики по конкретному интерактору в Grafana
  # без заведения отдельных метрик для каждого.

  # Сколько раз был вызван каждый интерактор.
  # Пример запроса в Grafana: rate(money_tracker_interaction_calls_total[5m])
  counter :interaction_calls_total,
          tags: [:interaction],
          comment: 'Total number of interaction calls'

  # Сколько вызовов завершились исключением и какого класса.
  # Тег :type — имя класса исключения (например: RuntimeError, Google::Apis::Error).
  counter :interaction_errors_total,
          tags: %i[interaction type],
          comment: 'Total number of interaction errors'

  # Время выполнения интерактора от вызова execute до его завершения.
  # buckets — границы бакетов в секундах. Из гистограммы можно вычислить p95/p99.
  histogram :interaction_duration_seconds,
            tags: [:interaction],
            buckets: [0.05, 0.1, 0.25, 0.5, 1, 2, 5, 10],
            comment: 'Time spent executing an interaction'
end
