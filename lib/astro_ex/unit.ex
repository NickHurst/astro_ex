defprotocol AstroEx.Unit do
  @moduledoc """
  AstroEx unit protocol
  """

  alias AstroEx.Unit.{Arcmin, Arcsec, Degrees, DMS, HMS, Radian}

  @type t :: Arcmin.t() | Arcsec.t() | Degrees.t() | DMS.t() | HMS.t() | Radian.t()

  @typep unit_module :: Arcmin | Arcsec | Degrees | DMS | HMS | Radian
  @typep number_module :: Integer | Float

  @spec cast(unit :: t(), to :: number_module() | unit_module()) :: t()
  def cast(unit, to)

  @spec from_degrees(degrees :: number() | Degrees.t()) :: t()
  def from_degrees(degrees)

  @spec to_string(unit :: t()) :: String.t()
  def to_string(unit)
end
