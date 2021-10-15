// code from: https://querypower.com/2017/02/24/powerquery-matrix-multiplication/

let
    MatrixMultiplication = (A,B) =>
    let
        //vector multiplication
        dotProduct = (v1,v2) =>
        List.Accumulate(
            List.Zip({v1,v2}),
            0,
            (agg, _) => agg + (_{1}*_{0})
        )

    in 
        Table.FromRows(
            List.Accumulate(
                Table.ToRows(A),
                {},
                (_,ai)=>
                    _& { List.Accumulate(
                            Table.ToColumns(B),
                            {},
                            (_,bj) =>
                                _&{ dotProduct(ai,bj) }
                        )
                        }
            )
        )
in
    MatrixMultiplication