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
  end
end
