defmodule DecimalArithmetic.Mixfile do
  use Mix.Project

  def project do
    [
      app: :decimal_arithmetic,
      version: "0.2",
      elixir: "~> 1.1",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: "Extended arithmetic for Decimal library.",
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:decimal, "~> 2.0"}
    ]
  end

  defp package do
    [
      contributors: ["Jacek Adamek", "Eduardo Barreto Alexandre"],
      maintainers: ["Eduardo Barreto Alexandre"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/sezaru/decimal_arithmetic"}
    ]
  end
end
