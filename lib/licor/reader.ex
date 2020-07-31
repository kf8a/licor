defmodule Licor.Reader do
  @moduledoc """
  Connect to the licor via a serial port, and then read the data stream and hold on to the last value
  """
  use GenServer

  require Logger

  alias Licor.Parser

  def start_link(serial_number) do
    GenServer.start_link(__MODULE__, %{port_serial: serial_number}, name: __MODULE__)
  end

  def init(%{port_serial: serial_number}) do
    {:ok, pid} = Circuits.UART.start_link

    {port, _} = Circuits.UART.enumerate
                |> find_port(serial_number)

    Circuits.UART.open(pid, port, speed: 9600, framing: {Circuits.UART.Framing.Line, separator: "\r\n"})
    {:ok, %{uart: pid, port: port}}
  end

  @doc """
  Helper function to find the right serial port
  given a serial number
  """
  def find_port(ports, serial_number) do
    Enum.find(ports, {"LICOR_PORT", ''}, fn({_port, value}) -> correct_port?(value, serial_number) end)
  end

  defp correct_port?(%{serial_number: number}, serial) do
    number ==  serial
  end

  defp correct_port?(%{}, serial) do
    false
  end

  def process_data(data, pid) do
    result = Parser.parse(data)
    Process.send(pid, {:parser, result}, [])
  end

  def port, do: GenServer.call(__MODULE__, :port)

  def current_value, do: GenServer.call(__MODULE__, :current_value)

  def handle_call(:current_value, _from, %{result: result} = state) do
    {:reply, result, state}
  end

  def handle_call(:port, _from, %{port: port} = state) do
    {:reply, port, state}
  end

  def handle_info({:circuits_uart, port, data}, state) do
    if port == state[:port] do
      Task.start(__MODULE__, :process_data, [data, self()])
    end
    {:noreply, state}
  end

  def handle_info({:parser, result}, state) do
    # Task.start(Licor.Logger, :save, [result])
    {:noreply, Map.put(state, :result, result)}
  end
end
