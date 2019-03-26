defmodule Casconf.Loader.Default do
  @behaviour Casconf.Loader

  def load(term) do
    {:found, term}
  end

  def describe_load(_) do
    "default value"
  end

  def source_description(_) do
    "Default value"
  end
end
