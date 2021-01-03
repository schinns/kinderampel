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
  @red 9
  @yellow 10
  @green 11

  def start(_type, _args) do
    spawn(fn -> check_time() end)
    {:ok, self()}
  end

  defp check_time do
    Logger.debug "Checking time"
    t = Time.utc_now
    pins = [@red, @yellow, @green]
    case {t.hour, t.minute} do
      # at 3:00 AM EST turn on red
      {8, 0} -> turn_on(@red)
      # at 7:00 AM EST turn on yellow light
      {12, 0} -> yellow_on_and_red_off()
      # at 7:30 AM EST turn on green
      {7, 30} -> green_on_and_yellow_off()
      # at 10:00 AM EST turn off green
      {15, 0} -> turn_off(@green)
      # at 7:00 PM EST loop lights to indicate bed time
      {24, 0} -> loop_lights(pins, 0)
      # at 7:01 PM EST clean up
      {24, 1} -> turn_off_all(pins, 1)
      _ -> Logger.debug("no match")
    end
    :timer.sleep(@check_interval)
    check_time()
  end

  defp yellow_on_and_red_off do
    {:ok, red} = Circuits.GPIO.open(@red, :output)
    {:ok, yellow} = Circuits.GPIO.open(@yellow, :output)

    # turn off red and turn yellow on
    Circuits.GPIO.write(red, 0)
    Circuits.GPIO.write(yellow, 1)
    Circuits.GPIO.close(red)
    Circuits.GPIO.close(yellow)
  end

  defp green_on_and_yellow_off do
    {:ok, yellow} = Circuits.GPIO.open(@yellow, :output)
    {:ok, green} = Circuits.GPIO.open(@green, :output)

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

  def loop_lights(pins, m) do
    if m == Time.utc_now.minute do
      [head_pin | tail_pins] = pins
      last_pin = List.last(pins)
      turn_on(head_pin)
      turn_off(last_pin)
      :timer.sleep(750)
      loop_lights(tail_pins ++ [head_pin], m)
    end
  end

  def turn_off_all(pins) do
    if length(pins) != 0 do
      [head_pin| tail_pins] = pins
      turn_off(head_pin)
      turn_off_all(tail_pins)
    end
  end
end
