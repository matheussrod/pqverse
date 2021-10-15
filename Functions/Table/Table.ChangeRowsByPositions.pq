(_table as table, row1 as number, row2 as number) as table =>

let
    _table_row1 = _table{row1},
    _table_row2 = _table{row2},

    change_first = 
    Table.RemoveRows(
        Table.InsertRows(
            _table, row1, {_table_row2}
        ),
        row1 + 1
    ),

    change_second = 
    Table.RemoveRows(
        Table.InsertRows(
            change_first, row2, {_table_row1}
        ),
        row2 + 1
    )

in
    change_second