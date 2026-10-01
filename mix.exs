defmodule Keychain.MixProject do
  use Mix.Project

  def project do
    [
      app: :keychain,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:rustler, "~> 0.37", runtime: false},
      {:propcheck, "~> 1.4", only: [:test, :dev]}
    ]
  end
end
