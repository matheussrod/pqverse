(_table as table, _number as number) as table =>

let
    columns_names = 
    Table.ColumnNames(_table),

    columns_zip = 
    List.Zip(
        {columns_names,
        List.Repeat({each _ / _number}, List.Count(columns_names)) }
    ),

    _table_multiply = 
    Table.TransformColumns(
        _table,
        columns_zip
    )

in
    _table_multiply