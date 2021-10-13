(_list as list, _number as number) as list =>

let
    subtract_by_number = 
    List.Transform(
        _list, 
        each _ - _number
    )

in
    subtract_by_number