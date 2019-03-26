defmodule Casconf do
  def get_env(application, key) do
    application
    |> Application.get_env(key)
    |> __MODULE__.Loader.load_in()
  end

  def get_all_env(application) do
    application
    |> Application.get_all_env()
    |> __MODULE__.Loader.load_in()
  end
end
