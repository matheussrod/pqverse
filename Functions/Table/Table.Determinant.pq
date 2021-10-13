(_table as table) as number => 

let   

    //auxiliary functions
    record_add_by_record = 
    @LibPQ("Record.AddByRecord"),

    record_mult_by_number = 
    @LibPQ("Record.MultiplyByNumber"),

    col_position = (_table as table, column) as list => 
    let
        column_name = Table.ColumnNames(_table){column},
        
        column_list = Table.Column(_table, column_name)
    in
        column_list,

    n_cols = Table.ColumnCount(_table),

    replace_row = (_table as table, row, _record as record) as table =>
    let 
        _table_replace = 
        Table.ReplaceRows(
            _table, 
            row,
            1,
            {_record}
        )
    in
        _table_replace,
    
    K = List.Numbers(0, n_cols - 1),

    K_table = Table.FromList(K, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    M_list =
    Table.AddColumn(
        K_table, 
        "M", 
        each List.Generate(() => [Column1] + 1, each _ < n_cols, each _ + 1)
        ),
    
    M_expand = 
    Table.ExpandListColumn(
        M_list, 
        "M"
    ),

    rename = Table.RenameColumns(M_expand,{{"Column1", "K"}}),
    full_list = Table.ToRows(rename),

    _table_triang = 
    List.Accumulate(
        full_list,
        _table, 
        (_table, idx) =>
            let

                F = Number.From(col_position(_table, idx{0}){idx{1}} / col_position(_table, idx{0}){idx{0}}),
                
                _record_mult = record_mult_by_number(_table{idx{0}}, F * (-1)),
                _record_old = _table{idx{1}},
                _record_sum = record_add_by_record(_record_old, _record_mult),

                _table_replace =
                replace_row(_table, idx{1}, _record_sum)

            in 
                _table_replace
    ),

    determinant = 
    List.Accumulate(
        List.Numbers(0, n_cols),
        1,
        (det, idx) =>
            det * col_position(_table_triang, idx){idx}
    )

in
    determinant