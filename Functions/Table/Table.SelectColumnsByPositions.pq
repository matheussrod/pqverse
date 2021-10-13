(_table as table, columns as list) as table => 

let
    columns_names = Table.ColumnNames(_table),
    
    columns_positions = 
    List.Positions(columns_names),

    columns_names_positions = 
    List.Zip(
        {columns_names, columns_positions}
    ),

    columns_filter = 
    List.Accumulate(
        columns_names_positions,
        {},
        (columns_filter, position) =>
            if List.ContainsAny(position, columns) then columns_filter & {position} else columns_filter
    ),

    columns_filter_name = 
    List.Transform(
        columns_filter, 
        each _{0}
    ),

    _table_selected = 
    Table.SelectColumns(
        _table, 
        columns_filter_name
    )
in
    _table_selected