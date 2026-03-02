class Calf < ApplicationRecord
  has_many :calf_events, dependent: :destroy

  enum status: { healthy: 0, sick: 1, dead: 2, sold: 3 }

  after_update :log_profile_update, if: :loggable_profile_change?

  after_create :log_created

  def administer_medication!(name:, dose: nil, occurred_at: Time.current, note: nil)
    parts = ["Medication administered: #{name}"]
    parts << "Dose: #{dose}" if dose.present?
    parts << note if note.present?

    calf_events.create!(
      event_type: :medication,
      occurred_at: occurred_at,
      medication_name: name,
      dose: dose,
      description: parts.join(" | ")
    )
  end

  private

  def loggable_profile_change?
    saved_change_to_status? || saved_change_to_weight_lbs?
  end

  def log_profile_update
    changes_lines = []

    # Status change (string values like "healthy" / "sick")
    if saved_change_to_status?
      from_status = status_before_last_save
      to_status   = status
      changes_lines << "Status: #{from_status} → #{to_status}"
    end

    # Weight change (numeric)
    if saved_change_to_weight_lbs?
      from_weight, to_weight = saved_change_to_weight_lbs
      changes_lines << "Weight: #{format_weight(from_weight)} → #{format_weight(to_weight)}"
    end

    calf_events.create!(
      event_type: :profile_update,   # add this to your enum (see below)
      occurred_at: Time.current,
      status_from: saved_change_to_status? ? Calf.statuses[status_before_last_save] : nil,
      status_to:   saved_change_to_status? ? Calf.statuses[status] : nil,
      weight_lbs:  saved_change_to_weight_lbs? ? weight_lbs : nil,
      description: changes_lines.join(" | ")
    )
  end

  def format_weight(value)
    return "—" if value.nil?
    # displays cleanly even if value is BigDecimal
    "#{value.to_d.to_f.round(2)} lbs"
  end

  def log_created
  calf_events.create!(
    event_type: :general,
    occurred_at: Time.current,
    description: "Calf record created with status #{status}"
  )
  end
end
