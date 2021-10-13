(_list1 as list, _list2 as list) as list =>

let
    subtract_by_list = 
    List.Accumulate(
        List.Zip({_list1, _list2}),
        {},
        (state, current) =>
            state & {current{0} - current{1}}
    )

in
    subtract_by_list