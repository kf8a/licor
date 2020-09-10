defmodule Licor do
  @moduledoc """
  Licor data struct
  """
  defstruct source: :licor, datetime: DateTime.utc_now(), co2: 0, temperature: 0,
    pressure: 0, co2_abs: 0, ivolt: 0, raw: 0

  @typedoc """
  A custom type that holds the data from the licor
  """

  @type t :: %Licor{source: :licor, datetime: DateTime, co2: Float, temperature: Float,
    pressure: Float, co2_abs: Float, ivolt: Float, raw: Float}
end
