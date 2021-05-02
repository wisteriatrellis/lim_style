defmodule LimStyle.Helper do
  def dfnx_tree({:=, _, [{name, _, _}, [{:->, _, [args, body]}]]}) do
    {:defn, [],
     [
       {name, [], args},
       [do: body]
     ]}
  end
end
