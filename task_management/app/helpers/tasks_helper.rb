module TasksHelper
  def date_Ymd(date)
    if date.nil?
      ""
    else
      date.strftime("%Y/%m/%d")
    end
  end
end
