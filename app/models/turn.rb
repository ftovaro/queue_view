class Turn < ApplicationRecord
  before_create :set_value

  enum :status, [:waiting, :active, :completed]

  def set_value
    max_value = Turn.maximum(:value)
    # .to_i here is to avoid an error if there are no turns created before
    # nil.to_i = 0
    self.value = max_value.to_i + 1
  end
end
