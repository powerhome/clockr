defmodule Clockr.ClockSupervisor do
  use Supervisor

  @moduledoc """
  Supervises Masterclock clocks. Does not start any on startup, but
  you can add clocks to be supervised using like this:

  Clockr.ClockSupervisor.start_clock(%{control_source_id: "1", clock_ip: '10.1.0.12'})

  If a clock started by this supervisor dies abnormally, it will be restarted, but
  a clock which is shut down cleanly will not.
  """

  @name Clockr.ClockSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_clock(masterclock_properties) do
    Supervisor.start_child(@name, [masterclock_properties])
  end

  def init(:ok) do
    children = [
      worker(Clockr.Masterclock, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
