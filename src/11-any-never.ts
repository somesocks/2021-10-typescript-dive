// any is the "gradual" in gradual typing

let a: any;
a = 1; // this works
a = '1'; // so does this
a = () => {}; // so does this

type foo = number;
type foo2 = foo & any; // foo2 = any
type foo3 = foo | any; // foo3 = any

let b: never;
b = 1; // error
b = '1'; // error
b = () => {}; // error

type bar = number;
type bar2 = bar & never; // bar2 = never
type bar3 = bar | never; // bar3 = number


let a: unknown;
a = 1; // this works
a = '1'; // so does this
a = () => {}; // so does this

type foo = number;
type foo2 = foo & unknown; // foo2 = number
type foo3 = foo | unknown; // foo3 = unknown

export default null;
