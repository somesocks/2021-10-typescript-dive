
// function definition w/ generic
function add<T>(a : T, B : T) : T {
	return (a as any) + (b as any);
}

//function as a variable with a generic
let add2 : <T>(a : T, B : T) => T = (a, b) => (a as any) + (b as any);



// typescript knows a is of type number
let a = add(1, 2);

// typescript knows b is of type string
let b = add('1', '2');

// compiler error
let c = add(1, '2');

export default null;