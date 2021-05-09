defmodule LimStyle do
  import LimStyle.Helper

  @moduledoc """  
  This package includes macros to write code using my style.
  It is for programmers who prefer Math style to do..end style.
  I will add more documents soon.
  
  ## Example
      import LimStyle

      dfmodule MyModule = (
        dfn func1 = (x -> x + 3)
        dfn func2 = ((a, b) -> 
          a * b
        )
      )
  """


  @doc """
  ## Example
      dfmodule MyModule = (
        # code...
      )
  """
  defmacro dfmodule({:=, _, [name, body]}) do
    quote do
      defmodule unquote(name) do
        unquote(body)
      end
    end
  end
  
  @doc """
  ## Example
      dfn func = (arg -> 
        :number
      ), if (is_number(arg))
      dfn func = (arg -> 
        :list
      ), if (is_list(arg))
  """
  defmacro dfn({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}, {:if, _, [condition]}) do
    dfn_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]}, {:if, nil, [condition]})
  end
  defmacro dfn({:=, _, [{name, _, _}, [{:->, _, [args, {:_, _, _}]}]]}) do
    dfn_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, {:_, nil, nil}]}]]})
  end
  defmacro dfn({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}) do
    dfn_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]})
  end

  ## Deprecated.
  ## I'm going to delete this.
  ## If you like this syntax, please let me know.
  defmacro dfn({:"::", _, [{:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}, condition]}) do
    dfn_tree({:"::", nil, [{:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]}, condition]})
  end
  ## Deprecated.
  ## I'm going to delete this.
  ## If you like this syntax, please let me know.
  defmacro dfn({:=, _, [{name, _, _}, {:~>, _, [args, body]}]}) do
    dfn_tree({:=, nil, [{name, nil, nil}, {:~>, nil, [args, body]}]})
  end

  defmacro dfconst({:=, _, [{name, _, _}, value]}) do
    dfconst_tree({:=, nil, [{name, nil, nil}, value]})
  end
  defmacro dfmacro({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}) do
    dfmacro_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]})
  end
  defmacro dfnx(arg) do
    dfnx_tree(arg)
  end

  defmacro dfnp({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}, {:if, _, [condition]}) do
    dfn_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]}, {:if, nil, [condition]})
    |> to_private
  end
  defmacro dfnp({:=, _, [{name, _, _}, [{:->, _, [args, {:_, _, _}]}]]}) do
    dfn_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, {:_, nil, nil}]}]]})
    |> to_private
  end
  defmacro dfnp({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}) do
    x = dfn_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]})
    |> to_private
    Macro.to_string(x) |> IO.puts
    x
  end
  defmacro dfnp({:"::", _, [{:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}, condition]}) do
    dfn_tree({:"::", nil, [{:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]}, condition]})
    |> to_private
  end
  defmacro dfnp({:=, _, [{name, _, _}, {:~>, _, [args, body]}]}) do
    dfn_tree({:=, nil, [{name, nil, nil}, {:~>, nil, [args, body]}]})
    |> to_private
  end
  defmacro dfconstp({:=, _, [{name, _, _}, value]}) do
    dfconst_tree({:=, nil, [{name, nil, nil}, value]})
    |> to_private
  end
  defmacro dfmacrop({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}) do
    dfmacro_tree({:=, nil, [{name, nil, nil}, [{:->, nil, [args, body]}]]})
    |> to_private
  end

  defp dfn_tree({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}, {:if, _, [condition]}) do
    {:def, [],
     [
       {:when, [],
        [
          {name, [], args},
          condition
        ]},
       [do: body]
     ]}
  end

  defp dfn_tree({:=, _, [{name, _, _}, [{:->, _, [args, {:_, _, _}]}]]}) do
    {:def, [],
     [
       {name, [], args},
     ]}
  end

  defp dfn_tree({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}) do
    {:def, [],
     [
       {name, [], args},
       [do: body]
     ]}
  end

  defp dfn_tree({:"::", _, [{:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}, condition]}) do
    {:def, [],
     [
       {:when, [],
        [
          {name, [], args},
          condition
        ]},
       [do: body]
     ]}
  end

  defp dfn_tree({:=, _, [{name, _, _}, {:~>, _, [args, body]}]}) do
    {:def, [],
     [
       {name, [], args},
       [do: body]
     ]}
  end

  defp dfconst_tree({:=, _, [{name, _, _}, value]}) do
    {:def, [],
     [
       {name, [], []},
       [do: value]
     ]}
  end

  defp dfmacro_tree({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}) do
    {:defmacro, [],
     [
       {name, [], args},
       [do: body]
     ]}
  end

  defp to_private({:def, meta, args}) when args |> is_list do
    {:defp, meta, args}
  end
  defp to_private({:defmacro, meta, args}) when args |> is_list do
    {:defmacrop, meta, args}
  end
  defp to_private({atom, meta, args}) do
    {atom, meta, args}
  end

  #defp dfs_ast({atom, meta, args}, func) when args |> is_list do
  #  {func.(atom), meta, args
  #  |> Enum.map(fn arg ->
  #     dfs_ast(arg, func)
  #   end)}
  #end
  #defp dfs_ast(atom, func) do
  #  func.(atom)
  #end

  defmacro the(var) do
    {:^, [], [var]}
  end

  defmacro lambda({:=, _, [{:_, _, _}, content]}) do
    {:fn, [], content}
  end

  @doc """
    Deprecated.
    I'm going to delete this.
    If you like this syntax, please let me know.
  """
  defmacro lmd({:=, _, [{:_, _, _}, content]}) do
    {:fn, [], content}
  end

  ## Deprecated.
  ## I'm going to delete this.
  ## If you like this syntax, please let me know.
  defmacro lmd(content) do
    {:fn, [], content}
  end

  defmacro branch(conditions) do
    quote do
      cond do: unquote(conditions |> to_cond_form)
    end
  end

  defp to_cond_form({:=, meta, [{:-, _, [:default]}, otherwise]}) do
    [{:->, meta, [[true], otherwise]}]
  end

  defp to_cond_form({:=, meta, [condition, value]}) do
    [{:->, meta, [[condition], value]}]
  end

  defp to_cond_form({:|, _, [{:=, meta, [{:-, _, [:default]}, otherwise]}, branches]}) do
    (branches |> to_cond_form) ++ [{:->, meta, [[true], otherwise]}]
  end

  defp to_cond_form({:|, _, [{:=, meta, [condition, value]}, branches]}) do
    [{:->, meta, [[condition], value]} | (branches |> to_cond_form)]
  end
end
