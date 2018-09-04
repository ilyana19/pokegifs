class PokemonController < ApplicationController
  def show
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{params[:id]}")
    body = JSON.parse(response.body)
    id = body["id"]
    name =  body["name"]
    types = types(body)

    gif_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV["GIPHY_KEY"]}&q=#{name}&rating=g")
    gif_body = JSON.parse(gif_response.body)
    gif_url = random_gif(gif_body)

    render json: {id: id, name: name, types: types, gif: gif_url}
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
