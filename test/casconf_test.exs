defmodule CasconfTest do
  use ExUnit.Case

  @pass_file "./DEMO_REPO_PASS.txt"

  setup do
    Application.put_env(:demo, Demo.Repo, [
      port: {:casconf, :integer, default: 5432, env: "DEMO_REPO_PORT"},
      host: {:casconf, default: "localhost", env: "DEMO_REPO_HOST"},
      username: {:casconf, default: "postgres", env: "DEMO_REPO_USER"},
      password: {:casconf, default: "postgres", env: "DEMO_REPO_PASS", file: @pass_file},
      pool_workers: 10
    ])
  end

  test "default values" do
    assert Casconf.get_env(:demo, Demo.Repo) == [
      port: 5432, host: "localhost",
      username: "postgres", password: "postgres",
      pool_workers: 10
    ]
  end

  test "password file" do
    on_exit(fn -> File.rm(@pass_file) end)
    File.write(@pass_file, "secret")
    assert Casconf.get_env(:demo, Demo.Repo) == [
      port: 5432, host: "localhost",
      username: "postgres", password: "secret",
      pool_workers: 10
    ]
  end
end
