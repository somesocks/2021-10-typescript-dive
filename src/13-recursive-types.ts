// recursive type definition!
type TReducer<A> = {
  init: (val: A) => TReducer<A>;
  update: (val: A) => TReducer<A>;
  finalize: () => A;
};

function NumberAdder(): TReducer<number> {
  let _state = 0;

  let _reducer = {
    init: (val: number) => {
      _state = val;
      return _reducer;
    },
    update: (val: number) => {
      _state += val;
      return _reducer;
    },
    finalize: () => _state,
  };

  return _reducer;
}

let numberAdder1 = NumberAdder();

// 6
let res = numberAdder1.init(1).update(2).update(3).finalize();

export default null;
