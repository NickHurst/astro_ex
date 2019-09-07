defmodule AstroEx.Unit.HMS do
  @moduledoc """
  Hours:Minutes:Seconds
  """

  alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, Radian}
  alias AstroEx.Utils.Math

  @enforce_keys [:value]
  defstruct [:value]

  @typep hours :: 12..23
  @typep minutes :: 0..59
  @typep seconds :: number()
  @typep hms :: {hours(), minutes(), seconds()}

  @type t :: %__MODULE__{value: hms()}

  @doc """


  ## Examples

      iex> AstroEx.Unit.HMS.new("12:00:00.0")
      #AstroEx.Unit.HMS<12:00:00.0>

  """
  def new(str) when is_binary(str),
    do: str |> parse_hms() |> new()

  def new({hrs, min, sec} = hms)
      when is_integer(hrs) and is_integer(min) and is_number(sec),
      do: %__MODULE__{value: hms}

  def new(hrs, min, sec),
    do: new({hrs, min, sec})

  @doc """


  ## Examples

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.HMS.to_degrees()
      #AstroEx.Unit.Degrees<180.0>

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Degrees)
      #AstroEx.Unit.Degrees<180.0>

  """
  def to_degrees(%__MODULE__{value: value}),
    do: value |> convert_to_degrees() |> Degrees.new()

  @doc """


  ## Examples

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.HMS.to_radian()
      #AstroEx.Unit.Radian<3.141593>

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Radian)
      #AstroEx.Unit.Radian<3.141593>

  """
  def to_radian(%__MODULE__{} = value),
    do: value |> to_degrees() |> Degrees.to_radian()

  @doc """


  ## Examples

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.HMS.to_arcsec()
      #AstroEx.Unit.Arcsec<648000.0>

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcsec)
      #AstroEx.Unit.Arcsec<648000.0>

  """
  def to_arcsec(%__MODULE__{} = value),
    do: value |> to_degrees() |> Arcsec.from_degrees()

  @doc """


  ## Examples

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.HMS.to_arcmin()
      #AstroEx.Unit.Arcmin<10800.0>

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcmin)
      #AstroEx.Unit.Arcmin<10800.0>

  """
  def to_arcmin(%__MODULE__{} = value),
    do: value |> to_degrees() |> Arcmin.from_degrees()

  @doc """


  ## Examples

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.HMS.to_dms()
      #AstroEx.Unit.DMS<180:00:00.0>

      iex> "12:00:00.0"
      ...> |> AstroEx.Unit.HMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.DMS)
      #AstroEx.Unit.DMS<180:00:00.0>

  """
  def to_dms(%__MODULE__{} = value),
    do: value |> to_degrees() |> DMS.from_degrees()

  @doc """


  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.HMS.from_degrees()
      #AstroEx.Unit.HMS<12:00:00.0>

  """
  def from_degrees(%Degrees{value: value}),
    do: from_degrees(value)

  def from_degrees(val) when is_integer(val),
    do: from_degrees(val * 1.0)

  def from_degrees(val) when is_float(val),
    do: val |> calculate_hms() |> new()

  defp parse_hms(str) do
    [hrs, min, sec] = String.split(str, ":")

    hrs = String.to_integer(hrs)
    min = String.to_integer(min)
    sec = String.to_float(sec)

    {hrs, min, sec}
  end

  defp calculate_hms(degrees) do
    degrees
    |> calculate_hrs()
    |> calculate_min()
    |> calculate_sec()
  end

  defp calculate_hrs(val), do: Math.divmod(val, 15)

  defp calculate_min({hrs, remdr}) do
    remdr
    |> (&(&1 * 60)).()
    |> Math.divmod(15)
    |> Tuple.insert_at(0, hrs)
  end

  defp calculate_sec({hrs, min, remdr}),
    do: {hrs, min, remdr * 60.0 * 15.0}

  defp convert_to_degrees({hrs, min, sec}),
    do: convert_to_degrees({min, sec}, hrs) * 15

  defp convert_to_degrees({min, sec}, sum),
    do: convert_to_degrees({sec}, sum + min / 60.0)

  defp convert_to_degrees({sec}, sum),
    do: sum + sec / 60.0 / 60.0

  defimpl AstroEx.Unit, for: __MODULE__ do
    alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS, Radian}

    def cast(%HMS{} = hms, Arcmin), do: HMS.to_arcmin(hms)
    def cast(%HMS{} = hms, Arcsec), do: HMS.to_arcsec(hms)
    def cast(%HMS{} = hms, Degrees), do: HMS.to_degrees(hms)
    def cast(%HMS{} = hms, DMS), do: HMS.to_dms(hms)
    def cast(%HMS{} = hms, HMS), do: hms
    def cast(%HMS{} = hms, Radian), do: HMS.to_radian(hms)
    def cast(%{value: value}, Float), do: value
    def cast(%{value: value}, Integer), do: trunc(value)

    def to_string(%{value: val}), do: val |> format_values() |> to_s()

    def from_degrees(val), do: HMS.from_degrees(val)

    defp to_s({hrs, min, sec}), do: "#{hrs}:#{min}:#{sec}"

    defp format_values({hrs, min, sec}),
      do: {pad(trunc(hrs)), pad(trunc(min)), pad(sec)}

    defp pad(val) when is_float(val) and val < 10,
      do: val |> Float.round(1) |> Float.to_string() |> pad(4)

    defp pad(val) when is_integer(val) and val < 10,
      do: val |> Integer.to_string() |> pad()

    defp pad(val) when is_integer(val),
      do: val |> Integer.to_string()

    defp pad(val) when is_float(val),
      do: val |> Float.round(2) |> Float.to_string()

    defp pad(val, n \\ 2) when is_binary(val),
      do: String.pad_leading(val, n, "0")
  end

  defimpl Inspect, for: __MODULE__ do
    alias AstroEx.Unit

    import Inspect.Algebra

    def inspect(value, _opts) do
      value = Unit.to_string(value)

      concat(["#AstroEx.Unit.HMS<", value, ">"])
    end
  end
end
