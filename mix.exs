defmodule LimStyle.MixProject do
  use Mix.Project

  @description """
    Macros to write code using my original syntax.
  """

  def project do
    [
      app: :lim_style,
      version: "0.1.1",
      elixir: "~> 1.11",
      name: "lim_style",
      description: @description,
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["limny"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/unlimtech/lim_style" }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      
    ]
  end
end
