module ApplicationHelper
  require "uri"

# URLに自動でリンクを貼る
  def text_url_to_link text

    URI.extract(text,['https','http']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end

    return text
  end

# ========================= _journal_list.html.erbで使用  ===========================
  # 借方金額表示
  def credit(journal,otherside)
    if otherside.present?

      if journal.details.first.account_id == 4 || journal.details.first.account_id == 3
        journal.details.first.otherside_id == otherside.id ? journal.figure : 0

      else
        0
      end

    else

      if journal.details.first.account_id == 4 || journal.details.first.account_id == 3
        journal.figure
      else
        0
      end

    end
  end

  # 貸方金額表示
  def debit(journal,otherside)
    if otherside.present?

      if journal.details.last.account_id == 4 || journal.details.last.account_id == 3
        journal.details.last.otherside_id == otherside.id ? journal.figure : 0
      else
        0
      end

    else

      if journal.details.last.account_id == 4 || journal.details.last.account_id == 3
        journal.figure
      else
        0
      end

    end
  end

# 貸方と借方の合計
  def balance(journal,otherside)

    if debit(journal,otherside) ==0 and credit(journal,otherside) ==0
      0
    else
      # return credit(journal,otherside) - debit(journal,otherside)
      return credit(journal,otherside) - debit(journal,otherside)
    end

  end

# journalの借方detailのaccount_idが3（債務）か4（立替金）の場合。liability:負債科目
  def journal_credit_is_liability?(journal)
    journal.details.first.account.character_status == 1
  end

# journalの借方detailのaccount_idが3（債務）か4（立替金）の場合。liability:負債科目
  def journal_debit_is_liability?(journal)
    journal.details.last.account.character_status == 1
  end

  def memo_exist?(obj)
    if obj.memo.blank? || obj.memo.body.blank?
      return false
    else
      return true
    end
  end

# sub取引先かmain取引先か
  def judge_sub_or_others(otherside)
    if Detail.where(otherside_id: otherside.id).any? && Journal.where(otherside_id: otherside.id).empty?
      true
    elsif Detail.where(otherside_id: otherside.id).empty? && Journal.where(otherside_id: otherside.id).empty? && Schedule.where(otherside_id: otherside.id).any?
      false
    else
      false
    end
  end

# 取引先種類によってアイコンを変える
  def sub_or_others_icon(otherside)
    if judge_sub_or_others(otherside)
      return "glyphicon glyphicon-user font-gray1"
    else
      return "glyphicon glyphicon-user"
    end
  end
# ========================= _total_loan.html.erbで使用  ===========================
# journalsから、配下のdetailsで利用されているotherside_idを配列化(create_otherside_list)、メインで使用してるothersideを除外(otherside_list)
# メインで使用しているothersideがnilの場合は除外せずに返す
  def create_otherside_list(journals)
    if journals.exists?
      list = Detail.where(journal_id:journals.map(&:id)).pluck(:otherside_id).uniq.flatten
      return list
    else
      return false
    end
  end

  def otherside_list(journals,otherside)
    if otherside&&journals.present?
      if create_otherside_list(journals).size == 1 #関連先が1つしかない＝メイン1件のみ
        false
      else
        create_otherside_list(journals).reject{|e| e == otherside.id}
      end
    else
      create_otherside_list(journals)
    end

  end


  # ========================= _schedule_list.html.erb  ===========================
# 清算・抽選をアイコン化する
  def check_fix_icon(schedule)
    if schedule.fix && schedule.check
      return "fas fa-check-square font-yellow1 mg-r-8 fa-lg"
    elsif schedule.fix
      return "fas fa-square font-yellow1 mg-r-8 fa-lg"
    elsif schedule.check
      return "fas fa-check-square font-gray1 mg-r-8 fa-lg"
    else
      return "fas fa-square font-gray1 mg-r-8 fa-lg"
    end
  end

  # 清算・抽選をアイコン化する　小
  def check_fix_smicon(schedule)
    if schedule.check
      return "fas fa-check mg-r-5"
    else
    end
  end

  # ========================= datetime_format  ===========================
  def format_wday(datetime)
    wday_names = %w(日 月 火 水 木 金 土)

    wday_names[datetime.wday]
  end

  def eventdate(event)
    s = String.new('')

    unless event.date_start.nil?
      s << event.date_start.strftime("%Y/%m/%d (#{format_wday(event.date_start)})")
    end

    unless event.date_end.nil?
      s << ' 〜 '
      s << event.date_end.strftime("%Y/%m/%d (#{format_wday(event.date_end)})")
    end

    s
  end

  def schedule_date(schedule)
    s = String.new('')
    s << schedule.start_datetime.strftime("%Y/%m/%d (#{format_wday(schedule.start_datetime)})")
    s << ' '

    s
  end

  # 時間に合わせてアイコンを変える
  # 6..16:sunny
  # それ以外:moon
  def schedule_matisowa(schedule)
    hour = schedule.start_datetime.hour

    if hour.between?(6,14)
      content_tag(:i, '',class:"far fa-sun")
    else
      content_tag(:i, '',class:"fas fa-moon")
    end

  end

  def schedule_time(schedule)
    s = String.new('')
    s << schedule.start_datetime.strftime("%H:%M")
    unless schedule.end_datetime.nil?
      s << ' - '
      s << schedule.end_datetime.strftime("%H:%M")
    end
    return s
  end

end
