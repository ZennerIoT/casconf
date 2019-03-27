# Casconf

Casconf allows you to setup cascading configuration loading.

## Basic usage

Consider this example matrix:

| config value | default | environment variable | file | 
|--------------|---------|----------------------|------|
| endpoint port | 4000   | `HTTP_PORT`          | N/A  |
| access password | nil  | `BASIC_AUTH_PASSWORD` | `/var/local/my_app/basic_auth` |

In Casconf, you could express it like this in your config.exs:

```elixir
config :app, Server,
  port: {:casconf, :integer, default: 4000, env: "HTTP_PORT"},
  basic_auth: {:casconf, default: nil, env: "BASIC_AUTH_PASSWORD", file: "/var/local/my_app/basic_auth"}
```

additionally, the order in which to load the sources can be configured like this:

```elixir
config :casconf, Casconf.Loader,
  sources: [
    file: Casconf.Loader.File,
    env: Casconf.Loader.Env,
    default: Casconf.Loader.Default
  ]
```

Now Casconf will try to load the configuration values from the configured sources in the order that was defined in the `Casconf.Loader` config.

That means that if a file source is given and the file exists, it will be used over an environment variable, which in turn will be tried before falling back on the default.

In your application, load the configuration with either `Casconf.get_env` or `Casconf.Loader.load_in`, depending on the 
way certain modules are configured.

When a library offers an init callback which already took the configuration from `Application.get_env` (like how Ecto and Phoenix do it),
you can implement the init callbacks in this fashion:

```elixir
defmodule App.Repo do
  use Ecto.Repo, otp_app: :app

  def init(_type, config) do
    config = Casconf.Loader.load_in(config)
    # maybe update some other settings here
    {:ok, config}
  end
end
```

Otherwise, use `Casconf.get_env`:

```elixir
server_config = Casconf.get_env(:app, Server)
```

## Features

 * **Cascading**
   
   Config sources will be tried in a configurable order

 * **Type casting**

   All types using the Ecto.Type behaviour are supported, as well as the builtin ecto types

 * **Extensible**

   `Casconf.Loader` is a behaviour you can implement when you need a different configuration source, for example a YAML file, or a database table.

   As `Ecto.Type` is used for casting the read values into the correct data types, custom types can also be used.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `casconf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:casconf, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/casconf](https://hexdocs.pm/casconf).

