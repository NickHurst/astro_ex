defmodule AstroEx.Unit.Degrees do
  @moduledoc """
  Degrees
  """

  alias AstroEx.Unit
  alias AstroEx.Unit.{Arcmin, Arcsec, DMS, HMS, Radian}

  @enforce_keys [:value]
  defstruct [:value]

  @typep degree :: -360..360 | float()
  @type t :: %__MODULE__{value: degree()}

  @doc """
  Creates a new `AstroEx.Unit.Degrees` struct

  ## Examples

      iex> AstroEx.Unit.Degrees.new(180)
      #AstroEx.Unit.Degrees<180.0>

      iex> AstroEx.Unit.Degrees.new(180.0)
      #AstroEx.Unit.Degrees<180.0>

  """
  def new(value) when is_float(value), do: %__MODULE__{value: value}
  def new(value) when is_integer(value), do: new(value * 1.0)

  @doc """
  Converts `AstroEx.Unit.Degrees` to a `AstroEx.Unit.Arcmin`

  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Degrees.to_arcmin()
      #AstroEx.Unit.Arcmin<10800.0>

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcmin)
      #AstroEx.Unit.Arcmin<10800.0>

  """
  def to_arcmin(%__MODULE__{value: value}),
    do: value |> Arcmin.from_degrees()

  @doc """
  Converts `AstroEx.Unit.Degrees` to a `AstroEx.Unit.Arcsec`

  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Degrees.to_arcsec()
      #AstroEx.Unit.Arcsec<648000.0>

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcsec)
      #AstroEx.Unit.Arcsec<648000.0>

  """
  def to_arcsec(%__MODULE__{value: value}),
    do: value |> Arcsec.from_degrees()

  @doc """
  Converts `AstroEx.Unit.Degrees` to a `AstroEx.Unit.DMS`

  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Degrees.to_dms()
      #AstroEx.Unit.DMS<180:00:00.0>

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.DMS)
      #AstroEx.Unit.DMS<180:00:00.0>

  """
  def to_dms(%__MODULE__{value: value}),
    do: value |> DMS.from_degrees()

  @doc """
  Converts `AstroEx.Unit.Degrees` to a `AstroEx.Unit.HMS`

  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Degrees.to_hms()
      #AstroEx.Unit.HMS<12:00:00.0>

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.HMS)
      #AstroEx.Unit.HMS<12:00:00.0>

  """
  def to_hms(%__MODULE__{value: value}),
    do: value |> HMS.from_degrees()

  @doc """
  Converts `AstroEx.Unit.Degrees` to a `AstroEx.Unit.Radian`

  ## Examples

      iex> degrees = AstroEx.Unit.Degrees.new(180)
      iex> AstroEx.Unit.Degrees.to_radian(degrees)
      #AstroEx.Unit.Radian<3.141593>

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Degrees.to_radian()
      #AstroEx.Unit.Radian<3.141593>

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Radian)
      #AstroEx.Unit.Radian<3.141593>

  """
  def to_radian(degrees), do: Radian.from_degrees(degrees)

  @doc """
  Returns the `AstroEx.Unit.Degrees` or converts a `Integer`/`Float`
  to a `AstroEx.Unit.Degrees`

  ## Examples

      iex> degrees = AstroEx.Unit.Degrees.new(15)
      iex> AstroEx.Unit.Degrees.from_degrees(degrees)
      #AstroEx.Unit.Degrees<15.0>

      iex> AstroEx.Unit.Degrees.from_degrees(15)
      #AstroEx.Unit.Degrees<15.0>

      iex> AstroEx.Unit.Degrees.from_degrees(180.0)
      #AstroEx.Unit.Degrees<180.0>

  """
  def from_degrees(%__MODULE__{} = deg), do: deg
  def from_degrees(val) when is_integer(val) or is_float(val), do: new(val)

  defimpl AstroEx.Unit, for: __MODULE__ do
    alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS, Radian}

    def cast(%Degrees{} = degrees, Arcmin), do: Degrees.to_arcmin(degrees)
    def cast(%Degrees{} = degrees, Arcsec), do: Degrees.to_arcsec(degrees)
    def cast(%Degrees{} = degrees, Degrees), do: degrees
    def cast(%Degrees{} = degrees, DMS), do: Degrees.to_dms(degrees)
    def cast(%Degrees{} = degrees, HMS), do: Degrees.to_hms(degrees)
    def cast(%Degrees{} = degrees, Radian), do: Degrees.to_radian(degrees)
    def cast(%{value: value}, Float), do: value
    def cast(%{value: value}, Integer), do: trunc(value)

    def to_string(%{value: value}) when is_integer(value),
      do: Integer.to_string(value)

    def to_string(%{value: value}) when is_float(value),
      do: :erlang.float_to_binary(value, [:compact, decimals: 6])

    def from_degrees(val), do: Degrees.from_degrees(val)
  end

  defimpl Inspect, for: __MODULE__ do
    alias AstroEx.Unit

    import Inspect.Algebra

    def inspect(value, _opts) do
      value = Unit.to_string(value)

      concat(["#AstroEx.Unit.Degrees<", value, ">"])
    end
  end
end
