(_record as record, _number as number) as record =>

let
    _record_names = 
    Record.FieldNames(_record),

    _record_values = 
    Record.FieldValues(_record),

    _list_subtract = 
    List.Transform(
        _record_values,
        each _ - _number
    ),

    subtract_by_number =
    Record.FromList(_list_subtract, _record_names)

in
    subtract_by_number