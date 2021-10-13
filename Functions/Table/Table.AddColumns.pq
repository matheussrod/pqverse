(_table as table, columns as list) as table => 

let
    mutate = 
    List.Accumulate(
        List.Numbers(0, List.Count(columns)), 
        _table, 
        (state, current) => 
            Table.AddColumn(state, columns{current}{0}, columns{current}{1})
    )

in
    mutate