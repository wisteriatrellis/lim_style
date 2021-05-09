defmodule LimStyleTest do
  use ExUnit.Case
  # doctest LimStyle
  import LimStyle

  dfmodule MyModule = (
    dfn func1 = (x -> x + 3)
    dfn func2 = ((a, b) -> 
      a * b
    )
  )

  test "dfmodule test" do
    import MyModule
    assert func1(2) + func2(3, 5) == 20
  end


  dfn func = (arg -> 
    :number
  ), if (is_number(arg))
  dfn func = (arg -> 
    :list
  ), if (is_list(arg))

  test "dfn with number test" do
    assert func(2.5) == :number
  end
  test "dfn with boolean test" do
    assert func([true, 4, "hello"]) == :list
  end

end
