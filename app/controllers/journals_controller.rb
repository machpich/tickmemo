class JournalsController < ApplicationController
  # before_action :authenticate_user!

  def index
    user = current_user
    @othersides = user.othersides
  end

  def create
    # journalを作成,paramsからschedule_idセット、othersideをセット
    @journal = Journal.new(journal_params)
    @journal.schedule_id = params[:schedule_id].to_i
    @journal.otherside = @journal.schedule.otherside

    # journalにセットした取引種類（trade_type)から、辞書の内容を元にdetailsを2行作成
    @journal.trade_type.trade_account_dicts.each do |tads|
      attributes = tads.attributes.slice("position_status", "account_id")
      @detail = @journal.details.build(attributes)

    #立替金の科目使用がある場合は関係者を新規作成
      if @detail.account_id == 4
        @otherside = Otherside.find_or_initialize_by(otherside_params)
        @otherside.user_id = current_user.id
        @otherside.save
        @detail.otherside = @otherside
      else
        @detail.otherside = @journal.schedule.otherside
      end
    end

    #journalと一緒にdetailsx2を更新
    if @journal.save
      redirect_to schedule_path(@journal.schedule)
    else
      redirect_to schedule_path(@journal.schedule)
    end
  end


  def multicreate
    # journalを作成　othersideをセット　schedule_idがないため、下部で補填
    @journal = Journal.new(journal_params)
    @journal.otherside = @journal.schedule.otherside

    # journalにセットした取引種類（trade_type)から、辞書の内容を元にdetailsを2行作成
    @journal.trade_type.trade_account_dicts.each do |tads|
      attributes = tads.attributes.slice("position_status", "account_id")
      @detail = @journal.details.build(attributes)

      #立替金がある場合は関係者を新規作成
      if @detail.account_id == 4
        @otherside = Otherside.find_or_initialize_by(otherside_params)
        @otherside.user_id = current_user.id
        @otherside.save
        @detail.otherside = @otherside
      else
        @detail.otherside = @journal.schedule.otherside
      end
    end

    if @journal.save
      redirect_to otherside_path(@journal.otherside)
    else
      redirect_to otherside_path(@journal.otherside)
    end

  end



  def edit
    @journal = Journal.find(params[:id])
    render 'schedules/show'
  end


  def destroy
    @journal = Journal.find(params[:id])
    if @journal.destroy
      redirect_back(fallback_location: root_path)
    else
      render 'schedules/show'
    end
  end

  def multidestroy
    @journal = Journal.find(params[:id])
    if @journal.destroy
      redirect_to schedule_path(@journal.schedule)
    else
      render 'othersides/show'
    end
  end


  private

  def otherside_params
    params.require(:otherside).permit(:otherside_name)
  end

  def journal_params
    params.require(:journal).permit(:schedule_id,:trade_date,:figure,:trade_type_id,memo_attributes:[:body,:id,:_destroy])
  end
end
