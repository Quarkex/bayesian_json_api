defmodule Api do
  @moduledoc """
  Api keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_anwsers(repository, element, query) do
    query = query
            |> String.replace(~r/^"(.*)"$/, "\\1")
            |> String.replace(~r/^'(.*)'$/, "\\1")

    %{ respuestas: "files/#{repository}/#{element}App.json"
    |> Api.read_json
    |> Api.bayes_classify(query)
    |> Enum.reject(fn({_id, probability}) -> probability == 0 end)
    |> Enum.sort_by(fn({_id, probability}) -> probability end, :desc)
    |> Enum.map(fn({id, _probability}) -> id end)
    }
  end

  def read_json(filename) do
     with {:ok, body} <- File.read(filename),
          {:ok, json} <- Phoenix.json_library.decode!(body), do: {:ok, json}
  end

  def get_dictionary(map) when is_map map do
    get_dictionary map["encabezados"], %{}
  end
  def get_dictionary([], acc) do
    acc
  end
  def get_dictionary([item | rest], acc) do
    get_dictionary rest, Map.put(acc, item["titulo"], item["id"])
  end

  def bayes_classify(dictionary, query) do
    get_dictionary(dictionary)
    |> build_bayes
    |> SimpleBayes.classify(query)
  end

  def build_bayes([], bayes) do
    bayes
  end
  def build_bayes([entry | rest], bayes) do
    build_bayes rest, SimpleBayes.train(bayes, elem(entry,0), elem(entry,1))
  end
  def build_bayes(map) when is_map map do
    build_bayes Enum.map(map, fn ({title, id}) -> {id, title} end), SimpleBayes.init()
  end

end
