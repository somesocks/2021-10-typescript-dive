const checkSameType: <T, U>(
  a: T &
    ((<G>() => G extends T ? 1 : 2) extends <G>() => G extends U ? 1 : 2
      ? unknown
      : never),
  b: U &
    ((<G>() => G extends T ? 1 : 2) extends <G>() => G extends U ? 1 : 2
      ? unknown
      : never)
) => (<G>() => G extends T ? 1 : 2) extends <G>() => G extends U ? 1 : 2
  ? unknown
  : never = (() => {}) as any;

let a = 1;
let b = 2;
let c = 'three';

checkSameType(a, b); // this line compiles

checkSameType(a, c); // this line throws a compiler error

export default null;
