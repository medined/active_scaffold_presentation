module PersonHelper
  def updated_at_column(record)
    if record.updated_at.respond_to? :format_short_date
      record.updated_at.format_short_date
    else
      record.updated_at
    end
  end
end

