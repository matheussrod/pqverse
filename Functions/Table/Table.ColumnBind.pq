(_table1 as table, _table2 as table) as table =>

let
    _table1_records = 
    List.Transform(
        Table.ToRows(_table1), 
        each Record.FromList(_, Table.ColumnNames(_table1))
    ),

    _table2_records = 
    List.Transform(
        Table.ToRows(_table2), 
        each Record.FromList(_, Table.ColumnNames(_table2))
    ),

    // TODO: Treat the case of tables with different number of lines
    bind_columns = 
    List.Accumulate(
        List.Numbers(0, List.Count(_table1_records)),
        {},
        (state, current) =>
            state & {_table1_records{current} & _table2_records{current}}
    ),

    _table1_table2 = 
    Table.FromRecords(
        bind_columns
    )
in
    _table1_table2