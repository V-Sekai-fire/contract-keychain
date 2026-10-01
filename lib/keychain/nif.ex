defmodule Keychain.Nif do
  @moduledoc """
  Rustler NIF over the Rust `keyring` crate. Every call runs on a dirty I/O scheduler,
  because the store can block, as when macOS asks to unlock the keychain.
  """
  use Rustler, otp_app: :keychain, crate: "keychain_nif"

  def get_password(_service, _user), do: :erlang.nif_error(:nif_not_loaded)
  def set_password(_service, _user, _password), do: :erlang.nif_error(:nif_not_loaded)
  def delete_password(_service, _user), do: :erlang.nif_error(:nif_not_loaded)
end
