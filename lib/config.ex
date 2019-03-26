defmodule Casconf.Config do
  defstruct type: :string, sources: []

  def value(type, sources) do
    %__MODULE__{type: type, sources: sources}
  end

end
