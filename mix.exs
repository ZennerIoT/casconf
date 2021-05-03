defmodule Casconf.MixProject do
  use Mix.Project

  def project do
    [
      app: :casconf,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: "Runtime config fed by static elixir expressions",
      deps: deps(),
      package: package(),
      source_url: "https://github.com/zenneriot/casconf"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package() do
    [
      name: "casconf",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/zenneriot/casconf"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
