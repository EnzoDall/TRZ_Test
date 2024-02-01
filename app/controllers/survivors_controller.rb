class SurvivorsController < ApplicationController
    before_action :set_survivor, only: [:show, :update, :update_location, :report_infection, :trade_items]
  
    # POST /survivors/1/trade
    def trade_items
      other_survivor_id = trade_params[:other_survivor_id]
      offered_items = trade_params[:offered_items]
      requested_items = trade_params[:requested_items]
  
      # Encontrar o outro sobrevivente com quem a troca será realizada
      other_survivor = Survivor.find_by_id(other_survivor_id)
      unless other_survivor
        render json: { error: 'Other survivor not found.' }, status: :not_found
        return
      end
  
      # Realizar a troca de itens
      result = @survivor.trade_items(other_survivor, offered_items, requested_items)
  
      if result == 'Trade successful.'
        render json: { message: result }, status: :ok
      else
        render json: { error: result }, status: :unprocessable_entity
      end
    end
  
    private
  
    # Usar callbacks para compartilhar configuração comum ou restrições entre ações
    def set_survivor
      @survivor = Survivor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Survivor not found.' }, status: :not_found
    end
  
    # Nunca confie em parâmetros da internet, apenas permita a lista branca através.
    def trade_items
        other_survivor = Survivor.find(trade_params[:other_survivor_id])
        if @survivor.infected? || other_survivor.infected?
          render json: { error: "Infected survivors cannot trade." }, status: :forbidden
          return
        end
    
        if @survivor.trade_with(other_survivor, trade_params[:offered_items], trade_params[:requested_items])
          render json: { message: "Trade successful." }, status: :ok
        else
          render json: { error: "Trade failed. Check item availability and points balance." }, status: :unprocessable_entity
        end
      end
    
      private
    
      def set_survivor
        @survivor = Survivor.find(params[:id])
      end
    
      def trade_params
        params.require(:trade).permit(:other_survivor_id, offered_items: [], requested_items: [])
      end
  end
  