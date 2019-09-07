defmodule AstroEx.Utils.Math do
  @moduledoc false

  @doc false
  def acos(val), do: :math.acos(val)

  @doc false
  def acosh(val), do: :math.acosh(val)

  @doc false
  def asin(val), do: :math.asin(val)

  @doc false
  def asinh(val), do: :math.asinh(val)

  @doc false
  def atan(val), do: :math.atan(val)

  @doc false
  def atan2(n1, n2), do: :math.atan2(n1, n2)

  @doc false
  def atanh(val), do: :math.atanh(val)

  @doc false
  def ceil(val), do: :math.ceil(val)

  @doc false
  def cos(val), do: :math.cos(val)

  @doc false
  def cosh(val), do: :math.cosh(val)

  @doc false
  def divmod(enum, denom),
    do: {trunc(enum / denom), rem(trunc(enum), trunc(denom))}

  @doc false
  def erf(val), do: :math.erf(val)

  @doc false
  def erfc(val), do: :math.erfc(val)

  @doc false
  def exp(val), do: :math.exp(val)

  @doc false
  def floor(val), do: :math.floor(val)

  @doc false
  def fmod(n1, n2), do: :math.fmod(n1, n2)

  @doc false
  def log(val), do: :math.log(val)

  @doc false
  def log10(val), do: :math.log10(val)

  @doc false
  def log2(val), do: :math.log2(val)

  @doc false
  def pi, do: :math.pi()

  @doc false
  def pow(val, n), do: :math.pow(val, n)

  @doc false
  def sin(val), do: :math.sin(val)

  @doc false
  def sinh(val), do: :math.sinh(val)

  @doc false
  def square(val), do: :math.pow(val, 2)

  @doc false
  def sqrt(val), do: :math.sqrt(val)

  @doc false
  def tan(val), do: :math.tan(val)

  @doc false
  def tanh(val), do: :math.tanh(val)

  @doc false
  def hypot(n1, n2), do: sqrt(square(n1) + square(n2))
end
