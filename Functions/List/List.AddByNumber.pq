(_list as list, _number as number) as list =>

let
    add_by_number = 
    List.Transform(
        _list, 
        each _ + _number
    )

in
    add_by_number