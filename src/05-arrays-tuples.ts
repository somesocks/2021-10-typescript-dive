let a: number[] = [1, 2, 3]; // array type

a[0] = 1; // compiles
a[0] = '1'; // error

a.push('4'); // error

let b: [number, string] = [1, '2']; // tuple type

b[1] = '2'; // compiles
b[1] = 2; // error

let c = b[3]; // out-of-bounds error

export default null;
