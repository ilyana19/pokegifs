class PokemonController < ApplicationController
  def show
    @id = pokemon_response["id"]
    @name =  pokemon_response["name"]
    @types = types(pokemon_response)
    @gif_url = random_gif(pokemon_gif_response)

    render json: {id: @id, name: @name, types: @types, gif: @gif_url}
  end

  def pokemon_response
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{params[:id]}")
    return JSON.parse(response.body)
  end

  def pokemon_gif_response
    gif_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV["GIPHY_KEY"]}&q=#{@name}&rating=g")
    return JSON.parse(gif_response.body)
  end

  def types(body)
    body["types"].map do |type|
      type["type"]["name"]
    end
  end

  def random_gif(body)
    body["data"].sample["url"]
  end
end
