// generics
type TReducer<A> = {
  init: (val: A) => void;
  update: (val: A) => void;
  finalize: () => A;
};

function NumberAdder(): TReducer<number> {
  let _state = 0;

  return {
    init: (val: number) => {
      _state = val;
    },
    update: (val: number) => {
      _state += val;
    },
    finalize: () => _state,
  };
}

let numberAdder1 = NumberAdder();
numberAdder1.init(1);
numberAdder1.update(2);
numberAdder1.update(3);

// 6
let res = numberAdder1.finalize();

export default null;
