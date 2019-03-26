defmodule Casconf.NoValueError do
  defexception [:sources]

  def exception(value) do
    struct(__MODULE__, Keyword.take(value, ~w[sources]a))
  end

  def message(%__MODULE__{} = error) do
    intro = "Tried to load a configuration value, but none of these sources are configured:"
    outro = "Configure at least one of the sources to continue loading"

    sources =
      Casconf.Loader.loaders()
      |> Enum.flat_map(fn {loader, module} ->
        case Keyword.get(error.sources, loader) do
          nil -> []
          key ->
            description = module.source_description(key)
            [" * #{description}"]
        end
      end)

    lines = [intro] ++ sources ++ [outro]
    Enum.join(lines, "\n")
  end
end
