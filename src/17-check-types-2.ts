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

// does T extend U AND does U extend T ?
// use stub function to get extra free variables(generics)
type _TIsEqual<T, U> = (<G>() => G extends T ? 1 : 2) extends <
  G
>() => G extends U ? 1 : 2
  ? unknown
  : never;

// use stub function to get extra free variables(generics),
// AND to trigger a compile error when equals check resolves to never
const checkSameType2: <T, U>(
  a: T & _TIsEqual<T, U>,
  b: U & _TIsEqual<T, U>
) => _TIsEqual<T, U> = (() => {}) as any;

export default null;
