defmodule Casconf.Types.URI do
  @behaviour Ecto.Type

  def type do
    :string
  end

  def cast(uri) when is_binary(uri) do
    {:ok, URI.parse(uri)}
  end

  def cast(%URI{} = uri) do
    {:ok, uri}
  end

  def load(uri) when is_binary(uri) do
    {:ok, URI.parse(uri)}
  end

  def dump(%URI{} = uri) do
    {:ok, URI.to_string(uri)}
  end
end
