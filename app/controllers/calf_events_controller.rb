class CalfEventsController < ApplicationController
  def medication
    calf = Calf.find(params[:calf_id])

    calf.administer_medication!(
      name: params.require(:calf_event).require(:medication_name),
      dose: params.dig(:calf_event, :dose),
      occurred_at: parse_occurred_at(params.dig(:calf_event, :occurred_at)),
      note: params.dig(:calf_event, :note)
    )

    redirect_to calf_path(calf), notice: "Medication event added."
  rescue ActiveRecord::RecordInvalid => e
    # If validation fails, re-render the show page with the errors
    @calf = calf
    @calf_event = calf.calf_events.new
    @calf_events = calf.calf_events.order(occurred_at: :desc)
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    render "calves/show", status: :unprocessable_entity
  end

  private

  def parse_occurred_at(value)
    return Time.current if value.blank?
    Time.zone.parse(value) || Time.current
  rescue ArgumentError
    Time.current
  end
end