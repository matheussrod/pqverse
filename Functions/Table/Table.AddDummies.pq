(_table as table, columns as list, optional prefix as logical, optional cat_columns as logical) as table =>

let

    prefix_adj = 
    if prefix = null then true else prefix,

    cat_columns_adj = 
    if cat_columns = null then true else cat_columns,

    Table.AddColumns = 
    @LibPQ("Table.AddColumns"),

    Table.ColumnBind = 
    @LibPQ("Table.ColumnBind"),

    dummies = 
    Table.ToColumns(
        Table.SelectColumns(
            _table,
            columns
        )
    ),
    
    dummies_uniques = 
    List.Transform(
        dummies,
        each List.Distinct(_)
    ),

    list_columns = 
    List.Accumulate(
        List.Numbers(0, List.Count(dummies)),
        {},
        (state, current) =>
            List.Accumulate(
                List.Numbers(0, List.Count(dummies_uniques{current})),
                {},
                (state2, current2) =>
                    let
                        replace_list = 
                        List.Transform(
                            List.Select(
                                dummies_uniques{current},
                                each _ <> dummies_uniques{current}{current2}
                            ),
                            each {_, "0"}
                        ) & {{dummies_uniques{current}{current2}, "1"}},

                        replace_list_items = 
                        List.Distinct(
                            state & 
                            state2 &
                            {
                                List.ReplaceMatchingItems(
                                    dummies{current}, 
                                     replace_list
                                )
                            }
                        )
                    in
                        replace_list_items                 
            )            
    ),

    quantity_columns_names =
    List.Accumulate(
        List.Numbers(0, List.Count(columns)),
        {},
        (state, current) =>
            state & List.Repeat({columns{current}}, List.Count(dummies_uniques{current}))
    ),

    dummies_columns_names = 
    List.Transform(
        List.Zip(
            {
                quantity_columns_names,
                List.Accumulate(
                    dummies_uniques,
                    {},
                    (state, current) =>
                        state & current
                )
            }
        ),
        each if prefix_adj then Text.Combine({_{0}, "_", _{1}}) else _{1}
    ),

    table_dummies  =
    Table.FromColumns(
        list_columns, 
        dummies_columns_names
    ),

    columns_bind = 
    Table.ColumnBind(
        if cat_columns_adj then _table else Table.RemoveColumns(_table, columns), 
        table_dummies
    )
in
    columns_bind