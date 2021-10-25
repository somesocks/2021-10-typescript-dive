type TNull = { kind: 'null' };

type TTrue = { kind: 'true' };
type TFalse = { kind: 'false' };
type TBoolean = TTrue | TFalse;

type TSymbolA = { kind: 'a' };
type TSymbolB = { kind: 'b' };
type TSymbolC = { kind: 'c' };
type TSymbol = TSymbolA | TSymbolB | TSymbolC;

type TIf = { kind: 'if' };
type TLet = { kind: 'let' };
type TDefine = { kind: 'define' };
type TNative = TIf | TLet | TDefine;

type TFunction = {
  kind: 'function';
  head: TSymbolList;
  tail: TAtom;
};

type TPair = {
  kind: 'pair';
  head: TAtom;
  tail: TAtom;
};

type TList = {
  kind: 'pair';
  head: TAtom;
  tail: TNull | TList;
};

type TSymbolList = {
  kind: 'pair';
  head: TSymbol;
  tail: TNull | TSymbolList;
};

type TAtom = TNull | TBoolean | TNative | TSymbol | TPair | TFunction;

type TContext = Record<string, TAtom>;

type TGetSymbol<T extends TSymbol, U extends TContext> = U[T['kind']];
type TSetSymbol<T extends TSymbol, U extends TAtom, V extends TContext> =
  T extends TSymbolA
    ? V & { a: U }
    : T extends TSymbolB
    ? V & { b: U }
    : T extends TSymbolC
    ? V & { c: U }
    : never;

type TEval<T extends TAtom, U extends TContext> = T extends TPair
  ? TEvalPair<T, U>
  : T extends TSymbol
  ? TGetSymbol<T, U>
  : T;

type TEvalPair<T extends TPair, U extends TContext> = T['head'] extends TNative
  ? TEvalNative<T['head'], T['tail'], U>
  : TEval<T['head'], U> extends TFunction
  ? TEvalFunction<TEval<T['head'], U>, TEval<T['tail'], U>, U>
  : { kind: 'pair'; head: TEval<T['head'], U>; tail: TEval<T['tail'], U> };

type TEvalNative<T extends TNative, U extends TAtom, V extends TContext> =
  T extends TIf
    ? TEvalIf<U, V>
    : T extends TLet
    ? TEvalLet<U, V>
    : T extends TDefine
    ? TEvalDefine<U, V>
    : never;

type TIfArgs = {
  kind: 'pair';
  head: TAtom;
  tail: {
    kind: 'pair';
    head: TAtom;
    tail: { kind: 'pair'; head: TAtom; tail: TNull };
  };
};

type TEvalIf<T extends TAtom, U extends TContext> = T extends TIfArgs
  ? TEval<T['head'], U> extends TTrue
    ? TEval<T['tail']['head'], U>
    : TEval<T['tail']['tail']['head'], U>
  : never;

type TLetArgs = {
  kind: 'pair';
  head: {
    kind: 'pair';
    head: TSymbol;
    tail: {
      kind: 'pair';
      head: TAtom;
      tail: TNull;
    };
  };
  tail: {
    kind: 'pair';
    head: TAtom;
    tail: TNull;
  };
};

type TEvalLet<T extends TAtom, U extends TContext> = T extends TLetArgs
  ? TEval<
      T['tail']['head'],
      TSetSymbol<T['head']['head'], TEval<T['head']['tail']['head'], U>, U>
    >
  : never;

type TDefineArgs = {
  kind: 'pair';
  head: TSymbolList;
  tail: {
    kind: 'pair';
    head: TAtom;
    tail: TNull;
  };
};

type TEvalDefine<T extends TAtom, U extends TContext> = T extends TDefineArgs
  ? { kind: 'function'; head: T['head']; tail: T['tail']['head'] }
  : never;

type TBindArgs<T extends TSymbolList, U extends TPair, V extends TContext> =
  TSetSymbol<T['head'], U['head'], V> &
    (T['tail'] extends TSymbolList
      ? U['tail'] extends TPair
        ? TBindArgs<T['tail'], U['tail'], V>
        : TContext
      : TContext);

type TEvalFunctionArgs = {
  kind: 'pair';
  head: TPair;
  tail: TNull;
};

type TEvalFunction<T extends TFunction, U extends TAtom, V extends TContext> =
  U extends TEvalFunctionArgs
    ? TEval<T['tail'], TBindArgs<T['head'], U['head'], V>>
    : never;

type TMakeList<T extends TAtom[]> = T extends [infer U]
  ? { kind: 'pair'; head: U; tail: TNull }
  : T extends [infer U, ...infer V]
  ? { kind: 'pair'; head: U; tail: V extends TAtom[] ? TMakeList<V> : never }
  : never;

// (if true false true) -> false
type PROG_IF_1 = {
  kind: 'pair';
  head: TIf;
  tail: {
    kind: 'pair';
    head: TTrue;
    tail: {
      kind: 'pair';
      head: TFalse;
      tail: { kind: 'pair'; head: TTrue; tail: TNull };
    };
  };
};

type RES_IF_1 = TEval<PROG_IF_1, TContext>;

// (if true false true) -> false
type PROG_IF_2 = TMakeList<[TIf, TTrue, TFalse, TTrue]>;

type RES_IF_2 = TEval<PROG_IF_2, TContext>;

// (let (a true) a) -> true
type PROG_LET_1 = TMakeList<[TLet, TMakeList<[TSymbolA, TTrue]>, TSymbolA]>;

type RES_LET_1 = TEval<PROG_LET_1, TContext>;

// (let (a true) (if a false true)) -> false
type PROG_LET_2 = TMakeList<
  [
    TLet,
    TMakeList<[TSymbolA, TTrue]>,
    TMakeList<[TIf, TSymbolA, TFalse, TTrue]>
  ]
>;

type RES_LET_2 = TEval<PROG_LET_2, TContext>;

// (define (a) a) -> func
type PROG_DEF_1 = TMakeList<[TDefine, TMakeList<[TSymbolA]>, TSymbolA]>;

type RES_DEF_1 = TEval<PROG_DEF_1, TContext>;

// ((define (a) a) (true)) -> true
type PROG_DEF_2 = TMakeList<
  [TMakeList<[TDefine, TMakeList<[TSymbolA]>, TSymbolA]>, TMakeList<[TTrue]>]
>;
type RES_DEF_2 = TEval<PROG_DEF_2, TContext>;

// ((define (a) (if a false true)) (true)) -> false
type PROG_INV_1 = TMakeList<
  [
    TMakeList<
      [
        TDefine,
        TMakeList<[TSymbolA]>,
        TMakeList<[TIf, TSymbolA, TFalse, TTrue]>
      ]
    >,
    TMakeList<[TTrue]>
  ]
>;
type RES_INV_1 = TEval<PROG_INV_1, TContext>;

export default null;
