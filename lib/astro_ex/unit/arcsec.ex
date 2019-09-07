defmodule AstroEx.Unit.Arcsec do
  @moduledoc """
  Arcsec
  """

  alias AstroEx.Unit.{Arcmin, Degrees, DMS, HMS, Radian}

  @enforce_keys [:value]
  defstruct [:value]

  @type t :: %__MODULE__{value: integer() | float()}

  @doc """


  ## Examples

      iex> AstroEx.Unit.Arcsec.new(60)
      #AstroEx.Unit.Arcsec<60>

  """
  def new(value) when is_number(value),
    do: %__MODULE__{value: value}

  @doc """


  ## Examples

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.Arcsec.to_degrees()
      #AstroEx.Unit.Degrees<0.016667>

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Degrees)
      #AstroEx.Unit.Degrees<0.016667>

  """
  def to_degrees(%__MODULE__{value: value}),
    do: Degrees.new(value / 3600.0)

  @doc """


  ## Examples

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.Arcsec.to_radian()
      #AstroEx.Unit.Radian<0.000291>

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Radian)
      #AstroEx.Unit.Radian<0.000291>

  """
  def to_radian(%__MODULE__{} = value),
    do: value |> to_degrees() |> Degrees.to_radian()

  @doc """


  ## Examples

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.Arcsec.to_arcmin()
      #AstroEx.Unit.Arcmin<1.0>

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.Arcmin)
      #AstroEx.Unit.Arcmin<1.0>

  """
  def to_arcmin(%__MODULE__{value: value}),
    do: Arcmin.new(value / 60.0)

  @doc """


  ## Examples

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.Arcsec.to_dms()
      #AstroEx.Unit.DMS<00:00:00.0>

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.DMS)
      #AstroEx.Unit.DMS<00:00:00.0>

  """
  def to_dms(%__MODULE__{} = value),
    do: value |> to_degrees() |> DMS.from_degrees()

  @doc """


  ## Examples

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.Arcsec.to_hms()
      #AstroEx.Unit.HMS<00:00:00.0>

      iex> 60
      ...> |> AstroEx.Unit.Arcsec.new()
      ...> |> AstroEx.Unit.cast(AstroEx.Unit.HMS)
      #AstroEx.Unit.HMS<00:00:00.0>

  """
  def to_hms(%__MODULE__{} = value),
    do: value |> to_degrees() |> HMS.from_degrees()

  @doc """


  ## Examples

      iex> 180
      ...> |> AstroEx.Unit.Degrees.new()
      ...> |> AstroEx.Unit.Arcsec.from_degrees()
      #AstroEx.Unit.Arcsec<648000.0>

  """
  def from_degrees(value), do: value |> calculate_arcsec() |> new()

  defp calculate_arcsec(%Degrees{value: value}),
    do: calculate_arcsec(value)

  defp calculate_arcsec(value) when is_integer(value) or is_float(value),
    do: value * 3600.0

  defimpl AstroEx.Unit, for: __MODULE__ do
    alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS, Radian}

    def cast(%Arcsec{} = arcsec, Arcmin), do: Arcsec.to_arcmin(arcsec)
    def cast(%Arcsec{} = arcsec, Arcsec), do: arcsec
    def cast(%Arcsec{} = arcsec, Degrees), do: Arcsec.to_degrees(arcsec)
    def cast(%Arcsec{} = arcsec, DMS), do: Arcsec.to_dms(arcsec)
    def cast(%Arcsec{} = arcsec, HMS), do: Arcsec.to_hms(arcsec)
    def cast(%Arcsec{} = arcsec, Radian), do: Arcsec.to_radian(arcsec)
    def cast(%{value: value}, Float), do: value
    def cast(%{value: value}, Integer), do: trunc(value)

    def to_string(%{value: value}) when is_integer(value),
      do: Integer.to_string(value)

    def to_string(%{value: value}) when is_float(value),
      do: :erlang.float_to_binary(value, [:compact, decimals: 6])

    def from_degrees(val), do: Arcsec.from_degrees(val)
  end

  defimpl Inspect, for: __MODULE__ do
    alias AstroEx.Unit

    import Inspect.Algebra

    def inspect(value, _opts) do
      value = Unit.to_string(value)

      concat(["#AstroEx.Unit.Arcsec<", value, ">"])
    end
  end
end
