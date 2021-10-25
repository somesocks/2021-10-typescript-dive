type TUnbox<A extends any[]> = A extends (infer U)[] ? U : never;

let arr1 = [1, 2, 3];

// works
let val1: TUnbox<typeof arr1> = 1;

// compile error
let val2: TUnbox<typeof arr1> = '1';

type TFirstArg<A extends any[]> = A extends [infer U] ? U : never;

let add = (a: number, b: number) => a + b;

// Tfoo = number
type TFoo = TFirstArg<Parameters<typeof add>>;

export default null;
