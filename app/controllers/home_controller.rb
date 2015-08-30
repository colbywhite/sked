class HomeController < ApplicationController
  def index
    @all = Game.eager_load_teams
    stndrd_excepts = [:id, :created_at, :updated_at]
    game_excepts = stndrd_excepts + [:home_id, :away_id]
    stndrd_excepts_opts = {except: stndrd_excepts}
    game_json_options = {include: {home: stndrd_excepts_opts, away: stndrd_excepts_opts}}
    game_json_options = game_json_options.merge({except: game_excepts})
    render json: @all.as_json(game_json_options)
  end
end
