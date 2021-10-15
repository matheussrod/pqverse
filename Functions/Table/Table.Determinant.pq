(_table as table) as number => 

let   
    Record.AddByRecord =
    @LibPQ("Record.AddByRecord"),

    Record.MultiplyByNumber = 
    @LibPQ("Record.MultiplyByNumber"),

    Table.ChangeRowsByPositions = 
    @LibPQ("Table.ChangeRowsByPositions"),

    col_position = (_table as table, column as number) as list => 
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
    
    K = List.Transform(List.Numbers(0, n_cols - 1), each {_}),
    K_table = #table({"K"}, K),

    M_list =
    Table.AddColumn(
        K_table, 
        "M", 
        each List.Generate(() => [K] + 1, each _ < n_cols, each _ + 1)
        ),
    
    M_expand = 
    Table.ExpandListColumn(
        M_list, 
        "M"
    ),

    full_list = Table.ToRows(M_expand),

    _table_p = 
    Table.AddColumn(
        _table, 
        "p",
        each 1
    ),

    fix0 = 
    if col_position(_table, 0){0} <> 0 then _table_p 
    else 
    List.Accumulate(
        full_list,
        _table_p,
        (_table_ac, idx) =>
            let
                replace_0 = 
                if col_position(_table_ac, idx{0}){idx{1}} = 0 then _table_ac 
                else 
                Table.TransformColumns(
                    Table.ChangeRowsByPositions(_table_ac, idx{0}, idx{1}),
                    {"p", each _ * (-1)}
                )       
            in
                replace_0
    ),

    _table_triang = 
    List.Accumulate(
        full_list,
        Table.RemoveColumns(
            fix0,
            {"p"}
        ), 
        (_table_fix0, idx) =>
            let
                F = Number.From(col_position(_table_fix0, idx{0}){idx{1}} / col_position(_table_fix0, idx{0}){idx{0}}),
                
                _record_mult = Record.MultiplyByNumber(_table_fix0{idx{0}}, F * (-1)),
                _record_old = _table_fix0{idx{1}},
                _record_sum = Record.AddByRecord(_record_old, _record_mult),

                _table_replace =
                replace_row(_table_fix0, idx{1}, _record_sum)

            in 
                _table_replace
    ),

    determinant = 
    if col_position(_table_triang, 0){0} = 0 then 0
    else
    List.Accumulate(
        List.Numbers(0, n_cols),
        1,
        (det, idx) =>
            det * col_position(_table_triang, idx){idx}
    ) * fix0[p]{0}

in
    determinant