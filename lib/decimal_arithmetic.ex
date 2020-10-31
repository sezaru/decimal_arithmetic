defmodule DecimalArithmetic do
  @moduledoc """
  Module extends embedded arithmetic with decimal one. If at least one operand of operation
  is of type Decimal.t the second one is promoted to Decimal struct too.

  ## Examples
      iex> a = ~m(98.01)
      #Decimal<98.01>
      iex> b = ~m(10.01)
      #Decimal<10.01>
      iex> c = a * b
      #Decimal<981.0801>
      iex> d = c / 77
      #Decimal<12.7413>
      iex> (a + b * c / d) * 3.14
      #Decimal<2727.9692>
      iex> net_price = ~m(34.78)
      #Decimal<34.78>
      iex> vat_rate = 23
      23
      iex> net_price * (1 + vat_rate / 100) |> Decimal.round(2)
      #Decimal<42.78>
  """

  alias Decimal, as: D

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [+: 2, -: 2, *: 2, /: 2, ==: 2, !=: 2, <: 2, >: 2, <=: 2, >=: 2]

      import unquote(__MODULE__)
    end
  end

  @doc """
  Adds two decimables or delegate addition to Kernel module.

  ## Examples
      iex> ~m(1) + 3.1415
      #Decimal<4.1415>
      iex> 1 + 3
      4
  """
  def a + b, do: do_add(a, b)

  defp do_add(%D{} = a, %D{} = b), do: D.add(a, b)
  defp do_add(%D{} = a, b) when is_number(b), do: D.add(a, to_decimal(b))
  defp do_add(a, %D{} = b) when is_number(a), do: D.add(to_decimal(a), b)
  defp do_add(a, b), do: Kernel.+(a, b)

  @doc """
  Subtracts two decimables or delegates subtraction to Kernel module.

  ## Examples
      iex> 3.19 - ~m(5.45)
      #Decimal<-2.26>
      iex> 3.20 - 5.45
      -2.25
  """
  def a - b, do: do_sub(a, b)

  defp do_sub(%D{} = a, %D{} = b), do: D.sub(a, b)
  defp do_sub(%D{} = a, b) when is_number(b), do: D.sub(a, to_decimal(b))
  defp do_sub(a, %D{} = b) when is_number(a), do: D.sub(to_decimal(a), b)
  defp do_sub(a, b), do: Kernel.-(a, b)

  @doc """
  Multiplies decimables or delegates multiplication to Kernel module.

  ## Examples
      iex> 7 * ~m(2.33)
      #Decimal<16.31>
  """
  def a * b, do: do_mult(a, b)

  defp do_mult(%D{} = a, %D{} = b), do: D.mult(a, b)
  defp do_mult(%D{} = a, b) when is_number(b), do: D.mult(a, to_decimal(b))
  defp do_mult(a, %D{} = b) when is_number(a), do: D.mult(to_decimal(a), b)
  defp do_mult(a, b), do: Kernel.*(a, b)

  @doc """
  Divides two decimables or delegates division to Kernel module.

  ## Examples
      iex> ~m(3) / 4
      #Decimal<0.75>
      iex> 3 / 4
      0.75
  """
  def a / b, do: do_div(a, b)

  defp do_div(%D{} = a, %D{} = b), do: D.div(a, b)
  defp do_div(%D{} = a, b) when is_number(b), do: D.div(a, to_decimal(b))
  defp do_div(a, %D{} = b) when is_number(a), do: D.div(to_decimal(a), b)
  defp do_div(a, b), do: Kernel./(a, b)

  @doc """
  Returns true if two decimable are equal or delegates equality to Kernel module.

  ## Examples
      iex> ~m(3.15) == 3.15
      true
      iex> ~m(5.304) == 5.304
      true
      iex> ~m(1.00001) == ~m(1.00002)
      false
  """
  def a == b, do: do_equal(a, b)

  defp do_equal(%D{} = a, %D{} = b), do: D.equal?(a, b)
  defp do_equal(%D{} = a, b) when is_number(b), do: D.equal?(a, to_decimal(b))
  defp do_equal(a, %D{} = b) when is_number(a), do: D.equal?(to_decimal(a), b)
  defp do_equal(a, b), do: Kernel.==(a, b)

  @doc """
  Returns true if two decimable are not equal.

  ## Examples
      iex> 3.15 != ~m(3.15)
      false
      iex> 1.00001 != ~m(1.00002)
      true
  """
  def a != b, do: !__MODULE__.==(a, b)

  @doc """
  Compares two decimables or delegates comparison to Kernel module.

  ## Examples
      iex> 3 > ~m(2)
      true
      iex> ~m(3) > 5
      false
      iex> ~m(2.21) > ~m(2.20)
      true
  """
  def a > b, do: do_greater(a, b)

  defp do_greater(%D{} = a, %D{} = b), do: D.compare(a, b) |> Kernel.==(:gt)

  defp do_greater(%D{} = a, b) when is_number(b),
    do: D.compare(a, to_decimal(b)) |> Kernel.==(:gt)

  defp do_greater(a, %D{} = b) when is_number(a),
    do: D.compare(to_decimal(a), b) |> Kernel.==(:gt)

  defp do_greater(a, b), do: Kernel.>(a, b)

  @doc """
  Compares two decimables.

  ## Examples
      iex> 3 >= ~m(2)
      true
      iex> ~m(3) >= 3
      true
      iex> ~m(2.20) >= ~m(2.21)
      false
  """
  def a >= b, do: __MODULE__.==(a, b) || __MODULE__.>(a, b)

  @doc """
  Compares two decimables or delegates comparison to Kernel module.

   ## Examples
      iex> 3 < ~m(2)
      false
      iex> ~m(3) < 5
      true
      iex> ~m(2.21) < ~m(2.20)
      false
  """
  def a < b, do: do_less(a, b)

  defp do_less(%D{} = a, %D{} = b), do: D.compare(a, b) |> Kernel.==(:lt)
  defp do_less(%D{} = a, b) when is_number(b), do: D.compare(a, to_decimal(b)) |> Kernel.==(:lt)
  defp do_less(a, %D{} = b) when is_number(a), do: D.compare(to_decimal(a), b) |> Kernel.==(:lt)
  defp do_less(a, b), do: Kernel.<(a, b)

  @doc """
  Compares two decimables.

  ## Examples
      iex> 3 <= ~m(2)
      false
      iex> ~m(3) <= 3
      true
      iex> ~m(2.20) <= ~m(2.21)
      true
  """
  def a <= b, do: __MODULE__.==(a, b) || __MODULE__.<(a, b)

  @doc """
  Casts string literal to Decimal.t.

  ## Examples
      iex> ~m[89.01]
      #Decimal<89.01>
      iex> ~m{34.34}
      #Decimal<34.34>
      iex> ~m(1)
      #Decimal<1>
  """
  def sigil_m(string, []), do: D.new(string)

  defp to_decimal(a) when is_integer(a), do: D.new(a)
  defp to_decimal(a) when is_float(a), do: D.from_float(a)
end
