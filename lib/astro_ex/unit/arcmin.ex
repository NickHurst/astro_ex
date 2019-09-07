defmodule AstroEx.Unit.Arcmin do
  @moduledoc """
  Arcmin unit
  """

  alias AstroEx.Unit.{Arcsec, Degrees, DMS, HMS, Radian}

  @enforce_keys [:value]
  defstruct [:value]

  @type arcmin :: pos_integer() | float()
  @type t :: %__MODULE__{value: arcmin()}

  @doc """
  Creates a new `AstroEx.Unit.Arcmin` struct

  ## Examples

      iex> AstroEx.Unit.Arcmin.new(10)
      #AstroEx.Unit.Arcmin<10>

  """
  def new(value) when is_number(value),
    do: %__MODULE__{value: value}

  @doc """
  Converts the `AstroEx.Unit.Arcmin` to a `AstroEx.Unit.Degree`

  ## Examples

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.Arcmin.to_degrees()
      #AstroEx.Unit.Degrees<0.166667>

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Degrees)
      #AstroEx.Unit.Degrees<0.166667>

  """
  def to_degrees(%__MODULE__{value: value}),
    do: Degrees.new(value / 60.0)

  @doc """


  ## Examples

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.Arcmin.to_radian()
      #AstroEx.Unit.Radian<0.002909>

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Radian)
      #AstroEx.Unit.Radian<0.002909>

  """
  def to_radian(%__MODULE__{} = value),
    do: value |> to_degrees() |> Degrees.to_radian()

  @doc """


  ## Examples

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.Arcmin.to_arcsec()
      #AstroEx.Unit.Arcsec<600.0>

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcsec)
      #AstroEx.Unit.Arcsec<600.0>

  """
  def to_arcsec(%__MODULE__{value: value}),
    do: Arcsec.new(value * 60.0)

  @doc """


  ## Examples

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.Arcmin.to_dms()
      #AstroEx.Unit.DMS<00:00:00.0>

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.DMS)
      #AstroEx.Unit.DMS<00:00:00.0>

  """
  def to_dms(%__MODULE__{} = value),
    do: value |> to_degrees() |> DMS.from_degrees()

  @doc """


  ## Examples

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.Arcmin.to_hms()
      #AstroEx.Unit.HMS<00:00:00.0>

      iex> 10
      ...> |> AstroEx.Unit.Arcmin.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.HMS)
      #AstroEx.Unit.HMS<00:00:00.0>

  """
  def to_hms(%__MODULE__{} = value),
    do: value |> to_degrees() |> HMS.from_degrees()

  @doc """


  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Arcmin.from_degrees()
      #AstroEx.Unit.Arcmin<10800.0>

  """
  def from_degrees(value), do: value |> calculate_arcmin() |> new()

  defp calculate_arcmin(%Degrees{value: value}),
    do: calculate_arcmin(value)

  defp calculate_arcmin(value) when is_integer(value) or is_float(value),
    do: value * 60.0

  defimpl AstroEx.Unit, for: __MODULE__ do
    alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS, Radian}

    def cast(%Arcmin{} = arcmin, Arcmin), do: arcmin
    def cast(%Arcmin{} = arcmin, Arcsec), do: Arcmin.to_arcsec(arcmin)
    def cast(%Arcmin{} = arcmin, Degrees), do: Arcmin.to_degrees(arcmin)
    def cast(%Arcmin{} = arcmin, DMS), do: Arcmin.to_dms(arcmin)
    def cast(%Arcmin{} = arcmin, HMS), do: Arcmin.to_hms(arcmin)
    def cast(%Arcmin{} = arcmin, Radian), do: Arcmin.to_radian(arcmin)
    def cast(%{value: value}, Float), do: value
    def cast(%{value: value}, Integer), do: trunc(value)

    def to_string(%{value: value}) when is_integer(value),
      do: Integer.to_string(value)

    def to_string(%{value: value}) when is_float(value),
      do: :erlang.float_to_binary(value, [:compact, decimals: 6])

    def from_degrees(val), do: Arcmin.from_degrees(val)
  end

  defimpl Inspect, for: __MODULE__ do
    alias AstroEx.Unit

    import Inspect.Algebra

    def inspect(value, _opts) do
      value = Unit.to_string(value)

      concat(["#AstroEx.Unit.Arcmin<", value, ">"])
    end
  end
end
