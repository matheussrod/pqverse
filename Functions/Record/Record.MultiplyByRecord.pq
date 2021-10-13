(_record1 as record, _record2 as record) as record =>

let
    _record_names = 
    Record.FieldNames(_record1),

    _record_values1 = 
    Record.FieldValues(_record1),

    _record_values2 = 
    Record.FieldValues(_record2),

    _list_multiply = 
    List.Accumulate(
        List.Zip({_record_values1, _record_values2}),
        {},
        (state, current) =>
            state & {current{0} * current{1}}
    ),

    multipy_by_record =
    Record.FromList(_list_multiply, _record_names)

in
    multipy_by_record