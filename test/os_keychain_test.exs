defmodule KeychainOSTest do
  # Runs against the real OS store: mix test --only os_keychain
  use ExUnit.Case, async: false
  @moduletag :os_keychain

  setup do
    pkg = "contract-keychain-test"
    svc = "run-#{System.unique_integer([:positive])}"
    on_exit(fn -> Keychain.delete_password(pkg, svc, "user") end)
    {:ok, pkg: pkg, svc: svc}
  end

  test "set, overwrite, get and delete through the OS store", %{pkg: pkg, svc: svc} do
    seed = Base.encode64(:crypto.strong_rand_bytes(32))
    assert {:error, :not_found} = Keychain.get_password(pkg, svc, "user")
    assert :ok = Keychain.set_password(pkg, svc, "user", "first")
    assert :ok = Keychain.set_password(pkg, svc, "user", seed)
    assert {:ok, ^seed} = Keychain.get_password(pkg, svc, "user")
    assert :ok = Keychain.delete_password(pkg, svc, "user")
    assert {:error, :not_found} = Keychain.get_password(pkg, svc, "user")
    assert {:error, :not_found} = Keychain.delete_password(pkg, svc, "user")
  end
end
