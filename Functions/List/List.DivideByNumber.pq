(_list as list, _number as number) as list =>

let
    divide_by_number = 
    List.Transform(
        _list, 
        each _ / _number
    )

in
    divide_by_number