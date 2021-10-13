(_record as record, _number as number) as record =>

let
    _record_names = 
    Record.FieldNames(_record),

    _record_values = 
    Record.FieldValues(_record),

    _list_multiply = 
    List.Transform(
        _record_values,
        each _ * _number
    ),

    multiply_by_number =
    Record.FromList(_list_multiply, _record_names)

in
    multiply_by_number