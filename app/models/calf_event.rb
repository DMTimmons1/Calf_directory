class CalfEvent < ApplicationRecord
  belongs_to :calf

  enum event_type: {
    general: 0,
    profile_update: 1,
    status_change: 2,
    medication: 3,
    weight_update: 4,
    note: 5
  }
end
