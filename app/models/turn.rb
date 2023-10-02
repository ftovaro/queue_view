class Turn < ApplicationRecord
  before_create :set_value

  enum :status, [:waiting, :active, :completed]

  def set_value
    self.value = Turn.waiting.count + 1
  end
end
