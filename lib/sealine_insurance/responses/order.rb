# frozen_string_literal: true

module SealineInsurance
  module Responses
    class Order < Base
      STATUSES = [
        'IN_PROGRESS',                    # Обрабатывается
        'ERROR',                          # Ошибка
        'UPDATE_IN_PROGRESS',             # Ожидает обновления
        'NOT_UPDATED',                    # Не обновлен
        'NEED_PAYMENT',                   # Требуется оплата
        'PAYMENT_IN_PROGRESS',            # Производится подтверждение оплаты
        'WAITING_FOR_DOCUMENTS',          # Загрузка электронного документа
        'DONE',                           # Создан
        'CANCEL_IN_PROGRESS',             # Ожидает отмены
        'WAITING_CANCELLATION_APPROVAL',  # Ожидает подтверждения отмены
        'REPEAT_CANCELLATION',            # Требуется повтор отмены
        'NOT_CANCELLED',                  # Не отменен
        'CANCELLED',                      # Отменен
      ].freeze

      def order_id
        body['id']
      end

      def status
        body['status']
      end

      def price
        Money.from_amount(body['price'].to_f, DEFAULT_CURRENCY) if body['price']
      end

      def documents
        body['documents'] || []
      end

      def external_numbers
        body['external_numbers'] || []
      end
    end
  end
end
