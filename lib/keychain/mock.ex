defmodule Keychain.Mock do
  @moduledoc """
  An ETS stand-in with the NIF's interface, so property tests run without the OS
  store: `Application.put_env(:keychain, :backend, Keychain.Mock)`.
  """
  @table :keychain_mock

  def start do
    if :ets.whereis(@table) == :undefined, do: :ets.new(@table, [:named_table, :public, :set])
    :ok
  end

  def reset, do: :ets.delete_all_objects(@table)

  def get_password(service, user) do
    case :ets.lookup(@table, {service, user}) do
      [{_, password}] -> {:ok, password}
      [] -> {:error, :not_found}
    end
  end

  def set_password(service, user, password) do
    :ets.insert(@table, {{service, user}, password})
    :ok
  end

  def delete_password(service, user) do
    case :ets.take(@table, {service, user}) do
      [] -> {:error, :not_found}
      _ -> :ok
    end
  end
end
