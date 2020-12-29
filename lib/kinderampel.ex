defmodule Kinderampel do
  @moduledoc """
  Documentation for Kinderampel.
  """

  @doc """
  Lights
  ## Examples
      iex> Kinderampel.turn_on(9)
      :ok
  """
  require Logger

  @check_interval 15000

  def start(_type, _args) do
    spawn(fn -> check_time() end)
    {:ok, self()}
  end

  defp check_time do
    Logger.debug "Checking time"
    t = Time.utc_now
    case {t.hour, t.minute} do
      # at 3:00 AM EST turn on red
      {8, 0} -> turn_on(9)
      # at 7:00 AM EST turn on yellow light
      {12, 0} -> yellow_on_and_red_off()
      # at 7:30 AM EST turn on green
      {7, 30} -> green_on_and_yellow_off()
      # at 10:00 AM EST turn off green
      {15, 0} -> turn_off(11)
      _ -> Logger.debug("no match")
    end
    :timer.sleep(@check_interval)
    check_time()
  end

  defp yellow_on_and_red_off do
    {:ok, red} = Circuits.GPIO.open(9, :output)
    {:ok, yellow} = Circuits.GPIO.open(10, :output)

    # turn off red and turn yellow on
    Circuits.GPIO.write(red, 0)
    Circuits.GPIO.write(yellow, 1)
    Circuits.GPIO.close(red)
    Circuits.GPIO.close(yellow)
  end

  defp green_on_and_yellow_off do
    {:ok, yellow} = Circuits.GPIO.open(10, :output)
    {:ok, green} = Circuits.GPIO.open(11, :output)

    # turn off yellow and turn green on
    Circuits.GPIO.write(yellow, 0)
    Circuits.GPIO.write(green, 1)
    Circuits.GPIO.close(yellow)
    Circuits.GPIO.close(green)
  end

  def turn_on pin do
    {:ok, gpio} = Circuits.GPIO.open(pin, :output)
    Circuits.GPIO.write(gpio, 1)
    Circuits.GPIO.close(gpio)
  end

  def turn_off pin do
    {:ok, gpio} = Circuits.GPIO.open(pin, :output)
    Circuits.GPIO.write(gpio, 0)
    Circuits.GPIO.close(gpio)
  end

  def toggle pin do
    {:ok, gpio} = Circuits.GPIO.open(pin, :output)
    case Circuits.GPIO.read(gpio) do
      1 -> Circuits.GPIO.write(gpio, 0)
      0 -> Circuits.GPIO.write(gpio, 1)
    end
    Circuits.GPIO.close(gpio)
  end
end
