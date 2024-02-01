class ReportsController < ApplicationController
    def infection_stats
      total_survivors = Survivor.count
      infected_count = Survivor.where(infected: true).count
      non_infected_count = total_survivors - infected_count
  
      render json: {
        total_survivors: total_survivors,
        infected_count: infected_count,
        non_infected_count: non_infected_count,
        infected_percentage: (infected_count.to_f / total_survivors * 100).round(2),
        non_infected_percentage: (non_infected_count.to_f / total_survivors * 100).round(2)
      }, status: :ok
    end
  end
  