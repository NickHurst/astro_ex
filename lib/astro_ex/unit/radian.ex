defmodule AstroEx.Unit.Radian do
  @moduledoc """
  Radian
  """

  alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS}
  alias AstroEx.Utils.Math

  @enforce_keys [:value]
  defstruct [:value]

  @type t :: %__MODULE__{value: integer() | float()}

  @doc """


  ## Examples

      iex> AstroEx.Unit.Radian.new(:math.pi)
      #AstroEx.Unit.Radian<3.141593>

  """
  def new(value) when is_number(value),
    do: %__MODULE__{value: value}

  @doc """


  ## Examples

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.Radian.to_degrees()
      #AstroEx.Unit.Degrees<180.0>

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Degrees)
      #AstroEx.Unit.Degrees<180.0>

  """
  def to_degrees(%__MODULE__{value: value}),
    do: Degrees.new(value / (Math.pi() / 180))

  @doc """


  ## Examples

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.Radian.to_arcmin()
      #AstroEx.Unit.Arcmin<10800.0>

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcmin)
      #AstroEx.Unit.Arcmin<10800.0>

  """
  def to_arcmin(%__MODULE__{} = value),
    do: value |> to_degrees() |> Arcmin.from_degrees()

  @doc """


  ## Examples

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.Radian.to_arcsec()
      #AstroEx.Unit.Arcsec<648000.0>

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcsec)
      #AstroEx.Unit.Arcsec<648000.0>

  """
  def to_arcsec(%__MODULE__{} = value),
    do: value |> to_degrees() |> Arcsec.from_degrees()

  @doc """


  ## Examples

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.Radian.to_dms()
      #AstroEx.Unit.DMS<180:00:00.0>

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.DMS)
      #AstroEx.Unit.DMS<180:00:00.0>

  """
  def to_dms(%__MODULE__{} = value),
    do: value |> to_degrees() |> DMS.from_degrees()

  @doc """


  ## Examples

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.Radian.to_hms()
      #AstroEx.Unit.HMS<12:00:00.0>

      iex> :math.pi
      ...> |> AstroEx.Unit.Radian.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.HMS)
      #AstroEx.Unit.HMS<12:00:00.0>

  """
  def to_hms(%__MODULE__{} = value),
    do: value |> to_degrees() |> HMS.from_degrees()

  @doc """


  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Radian.from_degrees()
      #AstroEx.Unit.Radian<3.141593>

  """
  def from_degrees(degrees),
    do: degrees |> calculate_radian() |> new()

  defp calculate_radian(%Degrees{value: value}), do: calculate_radian(value)
  defp calculate_radian(value), do: value * (Math.pi() / 180)

  defimpl AstroEx.Unit, for: __MODULE__ do
    alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS, Radian}

    def cast(%Radian{} = radian, Arcmin), do: Radian.to_arcmin(radian)
    def cast(%Radian{} = radian, Arcsec), do: Radian.to_arcsec(radian)
    def cast(%Radian{} = radian, Degrees), do: Radian.to_degrees(radian)
    def cast(%Radian{} = radian, DMS), do: Radian.to_dms(radian)
    def cast(%Radian{} = radian, HMS), do: Radian.to_hms(radian)
    def cast(%Radian{} = radian, Radian), do: radian
    def cast(%{value: value}, Float), do: value
    def cast(%{value: value}, Integer), do: trunc(value)

    def to_string(%{value: value}) when is_integer(value),
      do: Integer.to_string(value)

    def to_string(%{value: value}) when is_float(value),
      do: :erlang.float_to_binary(value, [:compact, decimals: 6])

    def from_degrees(val), do: Radian.from_degrees(val)
  end

  defimpl Inspect, for: __MODULE__ do
    alias AstroEx.Unit

    import Inspect.Algebra

    def inspect(value, _opts) do
      value = Unit.to_string(value)

      concat(["#AstroEx.Unit.Radian<", value, ">"])
    end
  end
end
