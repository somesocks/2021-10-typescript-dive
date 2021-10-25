let add = (a: number, b: number): number => a + b;

let a = add(1, 2); // compiles

let b = add(1, '2'); // error

let add2: (a: number, b: number) => number = (a, b) => a + b; // type inference!

let a2 = add2(1, 2); // compiles

let b2 = add2(1, '2'); // error

export default null;
