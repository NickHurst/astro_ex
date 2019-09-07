defmodule AstroEx.Unit.DMS do
  @moduledoc """
  Degrees Minutes Seconds
  """

  alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, HMS, Radian}
  alias AstroEx.Utils.Math

  @enforce_keys [:value]
  defstruct [:value]

  @typep degrees :: -360..360
  @typep minutes :: 0..59
  @typep seconds :: number()
  @typep dms :: {degrees(), minutes(), seconds()}

  @type t :: %__MODULE__{value: dms()}

  @doc """


  ## Examples

      iex> AstroEx.Unit.DMS.new("03:00:00.0")
      #AstroEx.Unit.DMS<03:00:00.0>

  """
  def new(str) when is_binary(str),
    do: str |> parse_dms() |> new()

  def new({deg, min, sec} = dms)
      when is_integer(deg) and is_integer(min) and is_number(sec),
      do: %__MODULE__{value: dms}

  def new(deg, min, sec),
    do: new({deg, min, sec})

  @doc """


  ## Examples

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.DMS.to_degrees()
      #AstroEx.Unit.Degrees<3.0>

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Degrees)
      #AstroEx.Unit.Degrees<3.0>

  """
  def to_degrees(%__MODULE__{value: value}),
    do: value |> convert_to_degrees() |> Degrees.new()

  @doc """


  ## Examples

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.DMS.to_radian()
      #AstroEx.Unit.Radian<0.05236>

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Radian)
      #AstroEx.Unit.Radian<0.05236>

  """
  def to_radian(%__MODULE__{} = value),
    do: value |> to_degrees() |> Degrees.to_radian()

  @doc """


  ## Examples

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.DMS.to_arcsec()
      #AstroEx.Unit.Arcsec<10800.0>

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcsec)
      #AstroEx.Unit.Arcsec<10800.0>

  """
  def to_arcsec(%__MODULE__{} = value),
    do: value |> to_degrees() |> Arcsec.from_degrees()

  @doc """


  ## Examples

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.DMS.to_arcmin()
      #AstroEx.Unit.Arcmin<180.0>

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcmin)
      #AstroEx.Unit.Arcmin<180.0>

  """
  def to_arcmin(%__MODULE__{} = value),
    do: value |> to_degrees() |> Arcmin.from_degrees()

  @doc """


  ## Examples

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.DMS.to_hms()
      #AstroEx.Unit.HMS<00:12:00.0>

      iex> "03:00:00.0"
      ...> |> AstroEx.Unit.DMS.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.HMS)
      #AstroEx.Unit.HMS<00:12:00.0>

  """
  def to_hms(%__MODULE__{} = value),
    do: value |> to_degrees() |> HMS.from_degrees()

  @doc """


  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.DMS.from_degrees()
      #AstroEx.Unit.DMS<180:00:00.0>

  """
  def from_degrees(%Degrees{value: value}), do: from_degrees(value)
  def from_degrees(val) when is_integer(val), do: from_degrees(val * 1.0)
  def from_degrees(val) when is_float(val), do: val |> calculate_dms() |> new()

  defp parse_dms(str) do
    [deg, min, sec] = String.split(str, ":")

    deg = String.to_integer(deg)
    min = String.to_integer(min)
    sec = String.to_float(sec)

    {deg, min, sec}
  end

  defp calculate_dms(degrees) do
    degrees
    |> calculate_deg()
    |> calculate_min()
    |> calculate_sec()
  end

  defp calculate_deg(val) when val < 0,
    do: val |> abs |> calculate_deg() |> invert_deg()

  defp calculate_deg(val), do: Math.divmod(val, 1)

  defp calculate_min({deg, remdr}) do
    remdr
    |> (&(&1 * 60)).()
    |> Math.divmod(1)
    |> Tuple.insert_at(0, deg)
  end

  defp calculate_sec({deg, min, remdr}),
    do: {deg, min, remdr * 60.0}

  defp invert_deg({deg, remdr}), do: {deg * -1.0, remdr}

  defp convert_to_degrees(%__MODULE__{value: value}),
    do: convert_to_degrees(value)

  defp convert_to_degrees({deg, _, _} = dms) when deg < 0,
    do: dms |> do_convert_to_degrees() |> (&(&1 * -1)).() |> (&(deg + &1)).()

  defp convert_to_degrees({deg, _, _} = dms),
    do: dms |> do_convert_to_degrees() |> (&(deg + &1)).()

  defp do_convert_to_degrees({_, min, sec}) do
    [min, sec / 60.0]
    |> Enum.sum()
    |> (&(&1 / 60.0)).()
  end

  defimpl AstroEx.Unit, for: __MODULE__ do
    alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS, Radian}

    def cast(%DMS{} = dms, Arcmin), do: DMS.to_arcmin(dms)
    def cast(%DMS{} = dms, Arcsec), do: DMS.to_arcsec(dms)
    def cast(%DMS{} = dms, Degrees), do: DMS.to_degrees(dms)
    def cast(%DMS{} = dms, DMS), do: dms
    def cast(%DMS{} = dms, HMS), do: DMS.to_hms(dms)
    def cast(%DMS{} = dms, Radian), do: DMS.to_radian(dms)
    def cast(%{value: value}, Float), do: value
    def cast(%{value: value}, Integer), do: trunc(value)

    def to_string(%{value: val}), do: val |> format_values() |> to_s()

    def from_degrees(val), do: DMS.from_degrees(val)

    defp to_s({deg, min, sec}), do: "#{deg}:#{min}:#{sec}"

    defp format_values({deg, min, sec}),
      do: {pad(trunc(deg)), pad(trunc(min)), pad(sec)}

    defp pad(val) when is_float(val) and val < 10,
      do: val |> Float.round(1) |> Float.to_string() |> pad(4)

    defp pad(val) when is_integer(val) and val < 10,
      do: val |> Integer.to_string() |> pad()

    defp pad(val) when is_integer(val),
      do: val |> Integer.to_string()

    defp pad(val) when is_float(val),
      do: val |> Float.round(1) |> Float.to_string()

    defp pad(val, n \\ 2) when is_binary(val),
      do: String.pad_leading(val, n, "0")
  end

  defimpl Inspect, for: __MODULE__ do
    alias AstroEx.Unit

    import Inspect.Algebra

    def inspect(value, _opts) do
      value = Unit.to_string(value)

      concat(["#AstroEx.Unit.DMS<", value, ">"])
    end
  end
end
