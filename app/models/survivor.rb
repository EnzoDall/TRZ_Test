class Survivor < ApplicationRecord
    # Associações
    has_many :items, dependent: :destroy
  
    # Validações
    validates :name, presence: true
    validates :age, presence: true, numericality: { greater_than: 0 }
    validates :gender, presence: true
    validates :latitude, presence: true, numericality: true
    validates :longitude, presence: true, numericality: true
    validates :infected, inclusion: { in: [true, false] }
  
    # Métodos de instância
  
    # Marca o sobrevivente como infectado
    def mark_as_infected
      update(infected: true)
    end
  
    def report_infection
        @survivor.report_infection
        if @survivor.is_infected
          render json: { message: "Survivor reported as infected and marked accordingly." }, status: :ok
        else
          render json: { message: "Survivor reported as infected." }, status: :ok
        end
    end
    
      private
        def set_survivor
          @survivor = Survivor.find(params[:id])
        end
    # Atualiza a localização do sobrevivente
    def update_location(latitude, longitude)
      update(latitude: latitude, longitude: longitude)
    end
  
    # Métodos de classe
  
    # Calcula a porcentagem de sobreviventes infectados
    def self.infected_percentage
      total_survivors = Survivor.count
      infected_survivors = Survivor.where(infected: true).count
      (infected_survivors.to_f / total_survivors) * 100
    end
  
    # Calcula a porcentagem de sobreviventes não infectados
    def self.non_infected_percentage
      100 - infected_percentage
    end
  
    # Relatório de distribuição de recursos
    def self.resource_distribution
      Item.joins(:survivor).where(survivors: { infected: false }).group(:name).count
    end
  
    def trade_items(other_survivor, offered_items, requested_items)
        # Verificar se algum dos sobreviventes está infectado
        return 'Trade cannot proceed. One or more survivors are infected.' if self.infected? || other_survivor.infected?
    
        # Calcular o total de pontos para itens oferecidos e solicitados
        offered_points = offered_items.sum { |item_id| self.items.find(item_id).points }
        requested_points = requested_items.sum { |item_id| other_survivor.items.find(item_id).points }
    
        # Verificar se os pontos se igualam
        return 'Trade points do not match.' unless offered_points == requested_points
    
        # Iniciar transação para assegurar a atomicidade da troca
        ActiveRecord::Base.transaction do
          # Remover itens do inventário do ofertante e adicioná-los ao inventário do solicitante
          offered_items.each do |item_id|
            item = self.items.find(item_id)
            item.survivor = other_survivor
            item.save!
          end
    
          # Remover itens do inventário do solicitante e adicioná-los ao inventário do ofertante
          requested_items.each do |item_id|
            item = other_survivor.items.find(item_id)
            item.survivor = self
            item.save!
          end
        end
    
        'Trade successful.'
      rescue => e
        # Em caso de erro, retornar a mensagem de erro
        "Trade failed: #{e.message}"
      end
    end
  end
  