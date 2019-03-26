defmodule Casconf.Loader.File do
  @behaviour Casconf.Loader

  def load(file) do
    case File.read(file) do
      {:ok, content} ->
        {:found, content}
      {:error, :enoent} ->
        :notfound
      {:error, :enotdir} ->
        :notfound
      {:error, o} ->
        {:error, o}
    end
  end

  def describe_load(file) do
    "loaded from file \"#{file}\""
  end

  def source_description(file) do
    "File \"#{file}\""
  end
end
