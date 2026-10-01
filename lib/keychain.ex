defmodule Keychain do
  @moduledoc """
  The operating system's secret store, one entry per package, service and user:
  Security.framework on macOS, the Credential Vault on Windows and the kernel keyring
  on Linux, through `Keychain.Nif`. The stored name is `package <> "." <> service`.
  """

  @doc "Returns `{:ok, password}`, `{:error, :not_found}` or `{:error, message}`."
  @spec get_password(String.t(), String.t(), String.t()) ::
          {:ok, String.t()} | {:error, :not_found | String.t()}
  def get_password(package, service, user),
    do: backend().get_password(service_name(package, service), user)

  @doc "Inserts or overwrites. Returns `:ok` or `{:error, message}`."
  @spec set_password(String.t(), String.t(), String.t(), String.t()) ::
          :ok | {:error, String.t()}
  def set_password(package, service, user, password),
    do: backend().set_password(service_name(package, service), user, password)

  @doc "Returns `:ok`, `{:error, :not_found}` or `{:error, message}`."
  @spec delete_password(String.t(), String.t(), String.t()) ::
          :ok | {:error, :not_found | String.t()}
  def delete_password(package, service, user),
    do: backend().delete_password(service_name(package, service), user)

  def service_name(package, service), do: package <> "." <> service

  defp backend, do: Application.get_env(:keychain, :backend, Keychain.Nif)
end
