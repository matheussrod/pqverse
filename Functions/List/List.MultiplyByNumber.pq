(_list as list, _number as number) as list =>

let
    multiply_by_number = 
    List.Transform(
        _list, 
        each _ * _number
    )

in
    multiply_by_number