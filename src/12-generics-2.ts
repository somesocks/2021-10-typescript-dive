// generics
type TReducer<A> = {
  init: (val: A) => void;
  update: (val: A) => void;
  finalize: () => A;
};

function NumberAverage(): TReducer<number> {
  let _state = 0;
  let _count = 0;

  return {
    init: (val: number) => {
      _state = val;
      _count++;
    },
    update: (val: number) => {
      _state += val;
      _count++;
    },
    finalize: () => _state / _count,
  };
}

let numberReducer1 = NumberAverage();
numberReducer1.init(1);
numberReducer1.update(2);
numberReducer1.update(3);

// res will equal 2
let res = numberReducer1.finalize();

export default null;
