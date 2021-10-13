(_record as record, _number as number) as record =>

let
    _record_names = 
    Record.FieldNames(_record),

    _record_values = 
    Record.FieldValues(_record),

    _list_divide = 
    List.Transform(
        _record_values,
        each _ / _number
    ),

    divide_by_number =
    Record.FromList(_list_divide, _record_names)

in
    divide_by_number