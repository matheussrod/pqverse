(_table as table, row as number) as table => 

let
    _record = _table{row - 1},

    _record_table = 
    Record.ToTable(_record),

    fill_down = 
    Record.FromTable(
        Table.FillDown(
            _record_table,
            {"Value"}
        )
    ),

    replace_row = 
    Table.ReplaceRows(
        _table, 
        row - 1, 
        1, 
        {fill_down}
    )

in
    replace_row