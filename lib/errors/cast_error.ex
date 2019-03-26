defmodule Casconf.CastError do
  defexception [
    loader: nil,
    loader_opts: nil,
    value: nil,
    type: nil
  ]

  def exception(value) do
    struct(__MODULE__, Keyword.take(value, ~w[loader loader_opts value type]a))
  end

  def message(%__MODULE__{} = error) do
    load_description = error.loader.describe_load(error.loader_opts)
    "Value #{inspect(error.value)} (#{load_description}) could not be converted to #{inspect error.type}"
  end
end
