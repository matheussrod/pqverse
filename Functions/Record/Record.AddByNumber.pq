(_record as record, _number as number) as record =>

let
    _record_names = 
    Record.FieldNames(_record),

    _record_values = 
    Record.FieldValues(_record),

    _list_add = 
    List.Transform(
        _record_values,
        each _ + _number
    ),

    add_by_number =
    Record.FromList(_list_add, _record_names)

in
    add_by_number