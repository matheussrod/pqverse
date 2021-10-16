(_table as table) as table => 

let
    Table.RemoveColumnsByPositions = 
    @LibPQ("Table.RemoveColumnsByPositions"),

    Table.Determinant = 
    @LibPQ("Table.Determinant"),

     n_cols = 
     Table.ColumnCount(
         _table
     ),

    columns_names = 
    Table.ColumnNames(
        _table
    ),

    idx_i = 
    #table(
        {"i"},
        
        List.Generate(
            () => 0,
            each _ < n_cols,
            each _ + 1,
            each {_}
        )        
    ),

    idx_j = 
    Table.ExpandListColumn(
        Table.AddColumn(
            idx_i,
            "j",
            each 
            List.Generate(
                () => 0,
                each _ < n_cols,
                each _ + 1
            )  
        ),
        "j"
    ),

    table_idx = 
    Table.AddColumn(
        idx_j, 
        "determinant", 
        each 
        Table.RemoveRows(
            Table.RemoveColumnsByPositions(
                _table, {[j]}
            ),
            [i]
        )
    ),

    table_cofactor = 
    Table.AddColumn(
        table_idx, 
        "cofactor", 
        each Table.Determinant([determinant]) * Number.Power((-1), [i] + [j] + 2)
    ),

   group_cofactor = 
   Table.Group(
       table_cofactor, 
       {"i"}, 
       {
           {"table_cofactor", each [cofactor]}
        }
    )[table_cofactor],

    table_adjunt = 
    Table.Transpose(
        #table(
            columns_names,
            group_cofactor
        )
    )
in
    table_adjunt