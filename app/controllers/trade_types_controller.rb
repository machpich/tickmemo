class TradeTypesController < ApplicationController
  def destroy
    @trade_type= TradeType.find(params[:id])
    @trade_type.destroy
    redirect_to trade_account_dicts_path
  end
end
