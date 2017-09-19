defmodule CloudVision.Mixfile do
  use Mix.Project

  def project do
    [app: :cloud_vision,
     version: "1.0.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :goth, :httpoison]]
  end

  def description do
    "Google Cloud Vision API Client in Elixir"
  end

  def package do
    [
      licenses: ["MIT License"],
      maintainers: ["Yuya Yabe"],
      links: %{
        "Github" => "https://github.com/yuyabee/cloud_vision",
        "Docs" => "https://hexdocs.pm/cloud_vision/"
      }
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:httpoison, "~> 0.11.0"},
      {:goth, git: "https://github.com/eamonpenland/goth"},
      {:poison, "~> 3.1"}
    ]
  end
end
