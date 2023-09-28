class TurnManagerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep 5.seconds
    p "I'm here"

    current_turn = Turn.waiting.order(:created_at).first
    return unless current_turn

    current_turn.update(status: :active)
    Turbo::StreamsChannel.broadcast_replace_to(
      :turns,
      target: ActionView::RecordIdentifier.dom_id(current_turn),
      partial: 'turns/turn',
      locals: { turn: current_turn }
    )

    sleep 10.seconds

    current_turn.update(status: :completed)

    Turbo::StreamsChannel.broadcast_replace_to(
      :turns,
      target: ActionView::RecordIdentifier.dom_id(current_turn),
      partial: 'turns/turn',
      locals: { turn: current_turn }
    )
  end
end
