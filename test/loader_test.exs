defmodule Casconf.LoaderTest do
  use ExUnit.Case

  alias Casconf.{Loader, Config}

  test "no sources" do
    config = %Config{type: :integer, sources: []}

    assert {:error, :notfound} == Loader.load(config)
  end

  test "env source" do
    env = "MY_INT_ENV"
    config = %Config{type: :integer, sources: [env: env]}

    System.put_env(env, "13")
    assert {:ok, 13} == Loader.load(config)

    System.delete_env(env)
    assert {:error, :notfound} = Loader.load(config)
  end

  test "default and env source" do
    env = "MY_INT_ENV_2"
    config = %Config{type: :integer, sources: [
      env: env,
      default: 0
    ]}

    assert {:ok, 0} == Loader.load(config)

    System.put_env(env, "10")
    assert {:ok, 10} == Loader.load(config)

    System.delete_env(env)
    assert {:ok, 0} == Loader.load(config)
  end

  test "file, env, and default sources" do
    env = "MY_STRING_ENV"
    file = "./#{env}.txt"
    # ensure file deletion in case test fails
    on_exit(fn -> File.rm(file) end)
    config = %Config{type: :string, sources: [
      file: file,
      env: env,
      default: "nothing"
    ]}

    assert {:ok, "nothing"} == Loader.load(config)

    System.put_env(env, "env")
    File.write(file, "file")
    assert {:ok, "file"} == Loader.load(config)

    File.rm(file)
    assert {:ok, "env"} == Loader.load(config)
  end
end
