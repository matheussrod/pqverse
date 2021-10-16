(_table, y as text, x as list, r2 as logical) as record => 

let
    Table.MatrixMultiplication = 
    @LibPQ("Table.MatrixMultiplication"),

    Table.MatrixInverse = 
    @LibPQ("Table.MatrixInverse"),

    X = 
    Table.ReorderColumns(
        Table.AddColumn(
            Table.SelectColumns(
                _table, 
                x
            ),
            "one",
            each 1
        ),
        {"one"} & x
    ),

    Y =
    Table.SelectColumns(
        _table,
        {y}
    ),

    coefficients = 
    Table.MatrixMultiplication(
        Table.MatrixInverse(Table.MatrixMultiplication(Table.Transpose(X), X)),
        Table.MatrixMultiplication(Table.Transpose(X), Y)
    )[Column1],

    // TODO: Put r2 analysis in a specific function
    r_analysis = 
    if not r2 then {null, null} 
    else 
        let 
            table_rows_X = 
            List.Transform(
                Table.ToRows(X),
                each 
                List.Zip({_, coefficients})
            ),

            table_rows_Y = 
            List.Transform(Table.ToRows(Y), each _{0}),

            prediction = 
            List.Transform(
                table_rows_X,
                each 
                List.Accumulate(
                    _,
                    0,
                    (state, current) => 
                        state + current{0} * current{1}
                )
            ),

            residual = 
            List.Transform(
                List.Zip(
                    {
                        table_rows_Y,
                        prediction
                    }
                ),
                each _{0} - _{1}
            ),

            average_obs = 
            List.Average(table_rows_Y),

            sq_tot = 
            List.Sum(
                List.Transform(
                    table_rows_Y,
                    each Number.Power(_ - average_obs, 2)
                )
            ),

            sq_res =
            List.Sum(
                List.Transform(
                    residual,
                    each Number.Power(_, 2)
                )
            ),

            r = 
            1 - (sq_res / sq_tot),

            n = 
            List.Count(residual),

            r_adj =
            1 - ((n - 1) / (n - (List.Count(x) + 1))) * (1 - r)

        in 
            {r, r_adj},

    results = 
    [coeffs = coefficients, r2 = r_analysis{0}, r2_adj = r_analysis{1}]

    // TODO: Implement coefficient significance test

in
    results