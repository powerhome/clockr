defmodule PhoenixApp.PhoenixDigestTask do
  use Mix.Releases.Plugin

  def before_assembly(%Release{} = _release) do
    case System.cmd("yarn", ["run", "deploy"]) do
      {output, 0} ->
        info output
        Mix.Task.run("phoenix.digest")
        nil
      {output, error_code} ->
        {:error, output, error_code}
    end
  end

  def after_assembly(%Release{} = _release) do
    nil
  end

  def before_package(%Release{} = _release) do
    nil
  end

  def after_package(%Release{} = _release) do
    nil
  end

  def after_cleanup(%Release{} = _release) do
    nil
  end
end
