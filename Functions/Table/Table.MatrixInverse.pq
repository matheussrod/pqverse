(_table as table) as table =>

let
    Table.Determinant = 
    LibPQ("Table.Determinant"),

    Table.MatrixAdjugate = 
    LibPQ("Table.MatrixAdjugate"),

    Table.MultiplyByNumber = 
    LibPQ("Table.MultiplyByNumber"),


    determinant = 
    Table.Determinant(_table),

    adjugate = 
    Table.MatrixAdjugate(_table),

    _table_inverse = 
    Table.MultiplyByNumber(adjugate, (1 / determinant)) 
in
    _table_inverse