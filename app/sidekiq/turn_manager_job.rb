class TurnManagerJob
  include Sidekiq::Job

  def perform(*args)
    while true
      sleep 10.seconds
      p "********************************"
      p "********************************"
      p "Running Job"
      p "********************************"
      p "********************************"
      turn = Turn.waiting.order(:created_at)&.first
      next unless turn

      turn.update(status: :active)
      Turbo::StreamsChannel.broadcast_replace_to(
        :turns,
        target: ActionView::RecordIdentifier.dom_id(turn),
        partial: 'turns/turn',
        locals: { turn: turn }
      )

      Turn.where(status: :waiting).update_all("value = value - 1")

      Turn.waiting.order(:created_at).each_with_index do |turn, index|
        Turbo::StreamsChannel.broadcast_replace_to(
          "counter", # target is the id of the turbo_frame_tag
          target: "counter_#{turn.id}", # id of the div inside the frame
          partial: 'turns/counter',
          locals: { turn: turn }
        )
      end

      sleep 3.seconds

      turn.update(status: :completed)

      Turbo::StreamsChannel.broadcast_replace_to(
        :turns,
        target: ActionView::RecordIdentifier.dom_id(turn),
        partial: 'turns/turn',
        locals: { turn: turn }
      )
    end
  end
end
