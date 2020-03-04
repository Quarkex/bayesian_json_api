defmodule ApiWeb.RepoController do
  use ApiWeb, :controller

  def index(conn, %{ "repository" => repository }) do

    element = if conn.body_params["elemento"] do
      conn.body_params["elemento"]
    else
      conn.query_params["elemento"]
    end

    query = if conn.body_params["pregunta"] do
      conn.body_params["pregunta"]
    else
      conn.query_params["pregunta"]
    end

    json(conn, Api.get_anwsers(repository, element, query))

  end
end
