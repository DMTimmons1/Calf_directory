module CalvesHelper
  def status_class(calf)
    if calf.sick?
      "status-sick"
    elsif calf.healthy?
      "status-healthy"
    else
      "status-neutral"
    end
  end
end