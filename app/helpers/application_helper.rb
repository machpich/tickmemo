module ApplicationHelper

# 借方金額表示
  def credit(journal)
    if journal.details.first.account_id == 3
      return journal.figure
    else
      return 0
    end
  end

# 貸方金額表示
  def debit(journal)
    if journal.details.last.account_id == 3
      return journal.figure
    else
      return 0
    end
  end

# 貸方と借方の合計
  def balance(journal)
    if debit(journal) ==0 and credit(journal) ==0
      return 0
    else
      return debit(journal) - credit(journal)
    end
  end

# 時間に合わせてアイコンを変える
# 6..16:sunny
# それ以外:moon
  def matisowa_icon(schedule)
    hour = schedule.start_datetime.hour
    if hour.between?(6,14)
      return "fas fa-sun"
    else
      return "fas fa-moon"
    end
  end

# 関係者を抽出してリストアップする
  def otherside_list(otherside)
    schedules = otherside.schedules
    list = []
    schedules.each do |schedule|
      list << schedule.details.pluck(:otherside_id)
    end
    list.flatten.uniq.reject{|e| e == otherside.id }
  end

end
