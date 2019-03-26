defmodule Casconf.Loader.Env do
  @behaviour Casconf.Loader

  def load(env) do
    case System.get_env(env) do
      nil -> :notfound
      value -> {:found, value}
    end
  end

  def describe_load(env) do
    "loaded from environment variable \"#{env}\""
  end

  def source_description(env) do
    "Environment variable \"#{env}\""
  end
end
