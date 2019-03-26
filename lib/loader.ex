defmodule Casconf.Loader do
  @callback load(term) :: :not_found | {:found, term} | {:error, reason :: term}
  @callback describe_load(term) :: String.t
  @callback source_description(term) :: String.t

  @default_loaders [
    file: Casconf.Loader.File,
    env: Casconf.Loader.Env,
    default: Casconf.Loader.Default
  ]

  @not_found_return {:error, :notfound}

  @doc """
  Loads a specific configuration item
  """
  @spec load_raw(Casconf.Config.t) :: {:found, key :: term, value :: term, loader_name :: atom} | {:error, reason :: term}
  def load_raw(%Casconf.Config{} = config) do
    Enum.reduce_while(loaders(), @not_found_return, fn({name, loader}, _acc) ->
      case Keyword.has_key?(config.sources, name) do
        true ->
          key = Keyword.get(config.sources, name)
          case loader.load(key) do
            {:found, value} ->
              {:halt, {:found, key, value, name}}
            :notfound ->
              {:cont, @not_found_return}
            {:error, _} = e ->
              {:halt, e}
          end
        false ->
          {:cont, @not_found_return}
      end
    end)
  end

  @doc """
  Loads and casts a specific configuration item

  It will raise the following errors:

   * Casconf.CastError (in case the supplied value couldn't be converted to the given data type)
   * Casconf.NoValueError (in case none of the loaders have found a value)
  """
  @spec load(Casconf.Config.t) :: {:ok, value :: term} | {:error, reason :: term}
  def load(%Casconf.Config{} = config) do
    case load_raw(config) do
      {:found, key, value, loader} ->
        case Ecto.Type.cast(config.type, value) do
          :error ->
            raise Casconf.CastError,
              loader: Keyword.get(loaders(), loader),
              loader_opts: key,
              value: value,
              type: config.type
          {:ok, value} ->
            {:ok, value}
        end
      {:error, :notfound} ->
        raise Casconf.NoValueError, sources: config.sources
      other ->
        other
    end
  end

  import Casconf.Config, only: [value: 2]

  @doc """
  Finds Casconf.Config structs in the given term (lists, keyword lists and maps supported)
  and
  """
  @spec load_in(term) :: term
  def load_in(term)
  def load_in({:casconf, sources}) do
    load_in(value(:string, sources))
  end
  def load_in({:casconf, type, sources}) do
    load_in(value(type, sources))
  end
  def load_in(%Casconf.Config{} = config) do
    case load(config) do
      {:ok, value} -> value
      {:error, _} = e -> raise e #TODO better error handling
    end
  end
  def load_in(list) when is_list(list) do
    Enum.map(list, fn
      {key, value} -> {key, load_in(value)}
      value -> load_in(value)
    end)
  end
  def load_in(%_{} = struct) do
    struct
  end
  def load_in(map) when is_map(map) do
    map
    |> Enum.to_list()
    |> load_in()
    |> Enum.into(%{})
  end
  def load_in(other) do
    # give up
    other
  end

  @doc """
  Returns the configured loaders in order of precedence
  """
  def loaders do
    :casconf
    |> Application.get_env(__MODULE__)
    |> Keyword.get(:loaders, @default_loaders)
  end
end
