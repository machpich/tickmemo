class TradeAccountDictsController < ApplicationController
  def index
    @trade_types = TradeType.all
    @trade_account_dict = TradeAccountDict.new
  end

  def new
  end

  def create
    @trade_account_dict = TradeAccountDict.new(trade_account_dict_params)
    if @trade_account_dict.save
      redirect_to trade_account_dicts_path
    else
      render 'trade_account_dicts/index'
    end
  end


  def destroy
    @trade_account_dict = TradeAccountDict.find(params[:id])
    if @trade_account_dict.destroy
      redirect_to trade_account_dicts_path
    else
      render 'trade_account_dicts/index'
    end
  end

  private
  def trade_account_dict_params
    params.require(:trade_account_dict).permit(:position_status,:trade_type_id,:account_id)
  end
end
